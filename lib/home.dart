import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gastrovita/attendance.dart';
import 'package:gastrovita/location.dart';
import 'package:gastrovita/sockets.dart';
import 'package:gastrovita/teste.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:gastrovita/exame.dart';
import 'package:gastrovita/info.dart';
import 'dart:convert' as convert;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  final String title = "Gastrovita Home";

  @override
  _HomePageState createState() => _HomePageState();
}

enum PageEnum {
  info,
  exame,
  attendance,
  doctor,
  home,
  sockets,
  location,
  geolocation
}

class _HomePageState extends State<HomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<dynamic> data;

  @override
  void initState() {
    super.initState();
    this.iniciarFirebaseListeners();
    this.getData();
  }

  void iniciarFirebaseListeners() {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase token " + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('mensagem recebida $message');
        this.mostrarAlert(
            message["notification"]["title"], message["notification"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<void> mostrarAlert(title, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(message)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('VOLTAR'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AttendancePage()));
              },
            ),
          ],
        );
      },
    );
  }

  void requisitarPermissoesParaNotificacoesNoIos() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  //Choices on go to the Pages in PopUpMenu
  _onSelect(PageEnum value) {
    switch (value) {
      case PageEnum.info:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InfoPage()));
        break;
      case PageEnum.exame:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExamePage()));
        break;
      case PageEnum.attendance:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AttendancePage()));
        break;
      case PageEnum.location:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LocationPage()));
        break;
      case PageEnum.geolocation:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TestePage()));
        break;
      default:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
    }
  }

  Future<dynamic> getLocation() async {
    final double placeLocationLatitude = -5.091214;
    final double placeLocationLongitude = -42.806561;

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final double userLocationLatitude = position.latitude;
    final double userLocationLongitude = position.longitude;
    final double distanceInMeters = await Geolocator().distanceBetween(
        userLocationLatitude,
        userLocationLongitude,
        placeLocationLatitude,
        placeLocationLongitude);

    return distanceInMeters;
  }

  Future<String> getData() async {
    var url = "https://jsonplaceholder.typicode.com/todos";

    // Await the http get response, then decode the json-formatted responce.
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    this.setState(() {
      data = convert.jsonDecode(response.body);
    });
    print(response.body);
  }

  Future<void> _getCheckinDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmação de CHECKIN?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja realizar o CHECK IN?'),
                Text('Lembre-se que essa ação não pode ser desfeita.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('NÃO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('SIM', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _verifyUserLocation();
              },
            ),
          ],
        );
      },
    );
  }

  _verifyUserLocation() async {
    double distance = await getLocation();

    if (distance > 0.2) {
      _errorLocation();
    } else {
      _getStateLocation();
    }
  }

  Future<void> _errorLocation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Você não está nas proximidades do Hospital! Por favor tente novamente.'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getStateLocation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Muito Obrigado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Seu checkin foi realizado com sucesso.'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TestePage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton<PageEnum>(
            onSelected: _onSelect,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<PageEnum>>[
              const PopupMenuItem<PageEnum>(
                value: PageEnum.home,
                child: Text('Inicial'),
              ),
              const PopupMenuItem<PageEnum>(
                value: PageEnum.info,
                child: Text('Informações'),
              ),
              const PopupMenuItem<PageEnum>(
                value: PageEnum.exame,
                child: Text('Resultado de Exames'),
              ),
              const PopupMenuItem<PageEnum>(
                value: PageEnum.attendance,
                child: Text('Atendente'),
              ),
            ],
          )
        ],
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/doctor.jpeg'),
                          ),

                          // title: Text(data[index]["title"]),
                          // subtitle: Text(data[index]["title"]),
                          title: Text("CARLOS DIMAS DE CARVALHO SOUSA"),
                          subtitle: new RichText(
                            text: new TextSpan(children: [
                              WidgetSpan(
                                child: new Icon(
                                  Icons.calendar_today,
                                  color: Colors.black26,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                  text: '  21/11\n',
                                  style: TextStyle(color: Colors.black26)),
                              WidgetSpan(
                                child: new Icon(
                                  Icons.alarm,
                                  color: Colors.black26,
                                  size: 20,
                                ),
                              ),
                              TextSpan(
                                  text: '  08h30.',
                                  style: TextStyle(color: Colors.black26)),
                            ]),
                          ),
                          contentPadding: EdgeInsets.all(8.0),
                          isThreeLine: true,
                          //subtitle: Text(Icon(Icons.calendar_today) . "20/01") . . Text(data[index]["title"]),
                        ),
                        ButtonTheme.bar(
                          // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              data[index]["completed"] == false
                                  ? RaisedButton(
                                      child: const Text(
                                        'FAZER CHECK-IN',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _getCheckinDialog();
                                      },
                                    )
                                  : RaisedButton(
                                      child: const Text(
                                        'CHECK-IN INDISPONIVEL',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: null,
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
