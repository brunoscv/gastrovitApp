import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrovita/attendance.dart';
import 'package:gastrovita/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permissions_plugin/permissions_plugin.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.getInt("paciente_id");

  //print(sharedPreferences.getInt("paciente_id"));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  final String title = "Check-In";

  final int id;

  HomePage({Key key, this.id}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  List<dynamic> data;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences sharedPreferences;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.iniciarFirebaseListeners();
    // requestLocationPermission();
    // _gpsService();
    _checkGps();
    _checkPermissions(context);
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

  Future<void> _checkPermissions(BuildContext context) async {
    final PermissionState aks =
        await PermissionsPlugin.isIgnoreBatteryOptimization;
    PermissionState resBattery;
    if (aks != PermissionState.GRANTED)
      resBattery = await PermissionsPlugin.requestIgnoreBatteryOptimization;

    Map<Permission, PermissionState> permission =
        await PermissionsPlugin.checkPermissions([
      Permission.ACCESS_FINE_LOCATION,
      Permission.ACCESS_COARSE_LOCATION,
    ]);
    if (permission[Permission.ACCESS_FINE_LOCATION] !=
            PermissionState.GRANTED ||
        permission[Permission.ACCESS_COARSE_LOCATION] !=
            PermissionState.GRANTED ||
        permission[Permission.READ_PHONE_STATE] != PermissionState.GRANTED) {
      try {
        permission = await PermissionsPlugin.requestPermissions([
          Permission.ACCESS_FINE_LOCATION,
          Permission.ACCESS_COARSE_LOCATION,
          Permission.READ_PHONE_STATE
        ]);
      } on Exception {
        debugPrint("Error");
      }

      if (permission[Permission.ACCESS_FINE_LOCATION] ==
              PermissionState.GRANTED &&
          permission[Permission.ACCESS_COARSE_LOCATION] ==
              PermissionState.GRANTED)
        print("Login ok");
      else
        _checkPermission(context);
    } else {
      print("Login ok");
    }
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
              child: Text('ESTOU A CAMINHO'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AttendancePage(id: widget.id)));
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

  Future _checkGpsCheckIn(int schedulingId) async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
    } else {
      _getCheckinDialog(schedulingId);
    }
  }

  Future<void> _getCheckinDialog(int schedulingId) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('CHECKIN:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tem certeza que deseja realizar o CHECK IN?'),
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
            FlatButton(
              color: Colors.blue,
              child: Text('SIM', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                //_verifyUserLocation(schedulingId);
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      // ignore: close_sinks
                      return AlertDialog(
                        title: Center(child: Text("Enviando ...")),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Center(child: Text("Realizando Check-In ..."))
                            ],
                          ),
                        ),
                      );
                    });
                _verifyUserLocation(schedulingId);
              },
            ),
          ],
        );
      },
    );
  }

  _verifyUserLocation(int schedulingId) async {
    double distance = await getLocation();

    if (distance > 200) {
      Navigator.of(context).pop();
      _errorLocation();
    } else {
      setState(() {
        isLoading = true;
      });
      await _schedulingCheckin(schedulingId);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
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
            FlatButton(
              color: Colors.blue,
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(id: widget.id)));
              },
            ),
          ],
        );
      },
    );
  }

  Future<http.Response> _schedulingCheckin(int schedulingId) async {
    Navigator.of(context).pop();
    final response = await http.get(
        "https://gastrovita.inkless.digital/api/inklessapp/schedulingcheckin/$schedulingId");
    final statusCode = response.statusCode;
    if (statusCode == 201) {
      setState(() {
        isLoading = false;
      });

      _getStateLocation();
    } else if (statusCode != 201 || response.body == null) {
      throw Exception("Error occured : [Status Code : $statusCode]");
      //_errorLocation();
    }
    return null;
  }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                  'Para melhores resultados, habilite a localização GPS do dispositivo, que utiliza o serviço de localização do Google.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('HABILITAR'),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _checkPermission(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              'Para melhores resultados, habilite a permissão de localização GPS do dispositivo, que utiliza o serviço de localização do Google.'),
          actions: <Widget>[
            FlatButton(
              child: Text('HABILITAR'),
              onPressed: () {
                final AndroidIntent intent = AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                intent.launch();
                Navigator.of(context, rootNavigator: true).pop();
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
            FlatButton(
              color: Colors.blue,
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(id: widget.id)));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buttonCheckin(String flag, int schedulingId) {
    if (flag == "Red") {
      return Container(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Card(
              elevation: 10,
              color: Colors.red[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.ban,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "Check-In Indisponível",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    } else if (flag == "Blue") {
      return Container(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Card(
              elevation: 10,
              color: Colors.lightBlue[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                onTap: () {
                  _checkGpsCheckIn(schedulingId);
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.userClock,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Fazer Check-In",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    } else {
      return Container(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Card(
              elevation: 10,
              color: Colors.lightGreen[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          FontAwesomeIcons.userCheck,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "Check-In Feito",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ));
    }
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
    // ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    //   return getErrorWidget(context, errorDetails);
    // };

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        actions: <Widget>[],
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: ShortSchedulingService.getUserScheduling(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final consultas = snapshot.data;
                  if (consultas.schedulings.length <= 0) {
                    return Container(
                      padding: EdgeInsets.only(top: 120, left: 40, right: 40),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.asset("assets/images/calendar.png"),
                          ),
                          SizedBox(height: 20),
                          Text(
                              "Você não possui agendamentos para a data de hoje.",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var schedulingId = consultas.schedulings[index].id;
                        var flag = consultas.schedulings[index].checkIn;
                        var time = Jiffy(
                            "${consultas.schedulings[index].timeStartingBooked}",
                            "hh:mm:ss");
                        var timeFormat = time.format("hh:mm");
                        var date = Jiffy(
                            "${consultas.schedulings[index].dateScheduling}",
                            "yyyy-MM-dd");
                        var dateFormat = date.format("dd/MM/yyyy");
                        return Column(children: <Widget>[
                          new Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: new Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: <Widget>[
                                  new Container(
                                      width: double.infinity,
                                      height: 150.0,
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
                                  Container(
                                    width: 200.0,
                                    height: 400.0,
                                  ),
                                  FractionalTranslation(
                                    translation: Offset(0.85, 0.4),
                                    child: new Container(
                                      alignment: new FractionalOffset(0.0, 0.0),
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://gastrovita.inkless.digital/storage/${consultas.schedulings[index].professionalImage}',
                                          width: 130,
                                          height: 130,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      width: 130.0,
                                      height: 130.0,
                                      padding: EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFFFFFFFF), // border color
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 450.0,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.only(top: 200.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                "${consultas.schedulings[index].professionalName}",
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.lightBlue[900],
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(height: 10),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                top: 0.0,
                                                right: 0,
                                                bottom: 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              child: Text(
                                                "HOSPITAL GASTROVITA",
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          Container(height: 10),
                                          Wrap(
                                            children: <Widget>[
                                              Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0),
                                                    child: Card(
                                                      elevation: 1,
                                                      color: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Icon(
                                                                    FontAwesomeIcons
                                                                        .clock,
                                                                    size: 30,
                                                                    color: Colors
                                                                            .lightBlue[
                                                                        900]),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Text(
                                                                    timeFormat,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightBlue[900])),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                  width: 100,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 30.0),
                                                    child: Card(
                                                      elevation: 1,
                                                      color: Colors.white,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Icon(
                                                                      FontAwesomeIcons
                                                                          .calendarCheck,
                                                                      size: 30,
                                                                      color: Colors
                                                                              .lightBlue[
                                                                          900])),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Text(
                                                                    dateFormat,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .lightBlue[900])),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                              _buttonCheckin(
                                                  flag, schedulingId),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ]);
                      },
                      itemCount: consultas.schedulings.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
