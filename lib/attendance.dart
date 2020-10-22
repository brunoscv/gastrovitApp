import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.getInt("paciente_id");

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendancePage(),
  ));
}

class AttendancePage extends StatefulWidget {
  final String title = "";

  final int id;

  // final String _messageImg = "Waiting for image..";
  // final String _messageText = "Waiting for message...";

  AttendancePage({Key key, this.id}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _messageText = "Waiting";
  String _messageImg = "Waiting";

  @override
  void initState() {
    super.initState();
    this.iniciarFirebaseListeners();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          this.mostrarAlert(message["notification"]["title"],
              message["notification"]["body"]);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          Map<String, dynamic> m = {};
          m['body'] = message["data"]["body"];
          _messageText = m['body'];
          m['image'] = message["data"]["image"];
          _messageImg = (m['image'] != null)
              ? m['image']
              : "https://pngimage.net/wp-content/uploads/2018/05/default-user-profile-image-png-7.png";
          print("Resume: $message");
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          Map<String, dynamic> m = {};
          m['body'] = message["data"]["body"];
          _messageText = m['body'];
          m['image'] = message["data"]["image"];
          // _messageImg = m['image'];
          _messageImg = (m['image'] != null)
              ? m['image']
              : "https://pngimage.net/wp-content/uploads/2018/05/default-user-profile-image-png-7.png";
          print("Launch :$message");
        });
      },
    );
  }

  Future<dynamic> iniciarFirebaseListeners() async {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase token " + token);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
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
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  child: Text(
                                    "Olá! Você tem uma nova notificação.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        '$_messageImg',
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(children: <Widget>[
                          Text(
                            _messageText,
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                            textAlign: TextAlign.justify,
                          ),
                          Container(
                            height: 10,
                          ),
                          SizedBox(
                            height: 60,
                            width: double.infinity,
                            child: RaisedButton(
                                color: Colors.lightBlue,
                                child: Text('VOLTAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () async {
                                  Navigator.pop(context);
                                }),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
