import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrovita/historic.dart';
import 'package:gastrovita/home.dart';
import 'package:gastrovita/info.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.getInt("paciente_id");

  //print(sharedPreferences.getInt("paciente_id"));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MenuPage(),
  ));
}

class MenuPage extends StatefulWidget {
  

  MenuPage({Key key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

enum PageEnum { info, exame, attendance, doctor, home, notifications }

class _MenuPageState extends State<MenuPage> {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage(id:sharedPreferences.getInt("paciente_id"))));
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

  _onCheckin() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(id:sharedPreferences.getInt("paciente_id"))));
  }

  _onHistoric() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HistoricPage(id:sharedPreferences.getInt("paciente_id"))));
  }

  _onPerfil() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InfoPage(id:sharedPreferences.getInt("paciente_id"))));
  }

  _onExame() {}

  @override
  Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      body: Stack(children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
          ),
          child: Center(),
        ),
        Container(
          margin: EdgeInsets.only(top: 80),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        onTap: () {
                          _onCheckin();
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.userCheck,
                                size: 80,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Check-in",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        onTap: () {
                         _onHistoric();
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.bookOpen,
                                size: 80,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Histórico",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        onTap: () {
                          _onPerfil();
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.userTag,
                                size: 80,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Perfil de Usuário",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        onTap: () {
                          _onExame();
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.userMd,
                                size: 80,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Exames",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // start at end/bottom of column
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              //  center in horizontal axis
              child: Image.asset(
                "assets/images/inkless-vertical-branca.png",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomLeft,
                width: 120.0,
                height: 120.0,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
