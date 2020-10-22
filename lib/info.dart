import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrovita/main.dart';
import 'package:gastrovita/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:string_mask/string_mask.dart';

void main() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.getInt("paciente_id");

  //print(sharedPreferences.getInt("paciente_id"));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InfoPage(),
  ));
}

//Return the list with Client Information
class InfoPage extends StatefulWidget {
  final String title = "Informações";
  final int id;

  InfoPage({Key key, this.id}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    this.iniciarFirebaseListeners();
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
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    ModalRoute.withName("/"));
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

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
    return Container(
      padding: EdgeInsets.only(top: 120, left: 40, right: 40),
      child: ListView(
        children: <Widget>[
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset("assets/images/wlan.png"),
          ),
          SizedBox(
            height: 20,
          ),
          Text("Verifique suas conexões com a Internet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Perfil"),
        backgroundColor: Colors.blue,
        actions: <Widget>[],
      ),
      //bottomSheet: ,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 37.0),
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                    future: SchedulingService.getUserScheduling(widget.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final profile = snapshot.data;
                        var cpf = StringMask('000.000.000-00');
                        final resultCpf = cpf.apply(profile.data.cpf);
                        final birth = formatDate(
                            DateTime.parse(profile.data.birth),
                            [dd, '/', mm, '/', yyyy]);
                        var image = (profile.data.image != null)
                            ? "https://gastrovita.inkless.digital/storage/${profile.data.image}"
                            : "https://pngimage.net/wp-content/uploads/2018/05/default-user-profile-image-png-7.png";
                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 0),
                              height: 400,
                              width: double.maxFinite,
                              child: new Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: new Stack(
                                    alignment: AlignmentDirectional.topStart,
                                    children: <Widget>[
                                      new Container(
                                          width: double.infinity,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            // Box decoration takes a gradient
                                            gradient: LinearGradient(
                                              // Where the linear gradient begins and ends
                                              begin: Alignment.topLeft,
                                              end: Alignment(0.8, 0.0),
                                              // Add one stop for each color. Stops should increase from 0 to 1
                                              stops: [0.1, 0.5, 0.7, 0.9],
                                              colors: [
                                                // Colors are easy thanks to Flutter's Colors class.
                                                Colors.blue[300],
                                                Colors.blue[400],
                                                Colors.blue[800],
                                                Colors.blue[900],
                                              ],
                                            ),
                                          )),
                                      FractionalTranslation(
                                        translation: Offset(0.8, 0.2),
                                        child: new Container(
                                          alignment:
                                              new FractionalOffset(0.0, 0.0),
                                          child: ClipOval(
                                            child: Image.network(
                                              image,
                                              width: 130,
                                              height: 130,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          width: 130.0,
                                          height: 130.0,
                                          padding: EdgeInsets.all(1.0),
                                          decoration: BoxDecoration(
                                            color: Color(
                                                0xFFFFFFFF), // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 310.0,
                                          child: Padding(
                                              padding: EdgeInsets.all(1),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 200.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          profile.data.name,
                                                          style: TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          top: 0.0,
                                                          right: 0,
                                                          bottom: 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          resultCpf,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          top: 0.0,
                                                          right: 0,
                                                          bottom: 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          birth,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          top: 0.0,
                                                          right: 0,
                                                          bottom: 0.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Text(
                                                          profile.data.cel,
                                                          style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ])))
                                    ]),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
