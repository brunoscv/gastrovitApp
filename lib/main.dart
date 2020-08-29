import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrovita/attendance.dart';
import 'package:gastrovita/historic.dart';
import 'package:gastrovita/home.dart';
import 'package:gastrovita/info.dart';
import 'package:gastrovita/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget _defaultHome = new MainPage();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int pacienteId = prefs.getInt("paciente_id");
  //print(pacienteId);
  if (pacienteId == null) {
    _defaultHome = new LoginPage();
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(id: pacienteId),
      '/login': (BuildContext context) => new LoginPage(),
      '/historic': (BuildContext context) => new HistoricPage(id: pacienteId),
      '/attendance': (BuildContext context) =>
          new AttendancePage(id: pacienteId),
    },
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    checkLoginStatus();
    this.iniciarFirebaseListeners();
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    int pacienteId = sharedPreferences.getInt("paciente_id");
    return pacienteId;
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final String pagechooser = message["data"]['screen'];
    Navigator.pushNamed(context, pagechooser);
  }

  void iniciarFirebaseListeners() {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    _firebaseMessaging.getToken().then((token) {
      print("Firebase token: " + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('mensagem recebida $message');
        this.mostrarAlert(
            message["notification"]["title"], message["notification"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        _navigateToItemDetail(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        _navigateToItemDetail(message);
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

  Widget checkinBlock() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        child: Card(
          elevation: 10,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                          id: sharedPreferences.getInt("paciente_id"))));
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 80,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Check-In",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget historicBlock() {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
      child: Card(
        elevation: 10,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoricPage(
                        id: sharedPreferences.getInt("paciente_id"))));
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.bookReader,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Agendamentos",
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

  Widget fileBlock() {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
      child: Card(
        elevation: 10,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InfoPage(id: sharedPreferences.getInt("paciente_id"))));
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.file,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Laudos",
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

  Widget documentBlock() {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
      child: Card(
        elevation: 10,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        InfoPage(id: sharedPreferences.getInt("paciente_id"))));
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.folder,
                  size: 80,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Documentos",
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

  Widget logoutBlock() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
        child: Card(
          elevation: 10,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: InkWell(
            onTap: () {
              sharedPreferences.clear();
              sharedPreferences.remove("paciente_id");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
            },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FontAwesomeIcons.signOutAlt,
                    size: 80,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sair",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget footerSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/images/inkless-vertical-branca.png",
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
            width: 120.0,
            height: 120.0,
          ),
        ),
      ],
    );
  }

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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 0.7, 0.9],
              colors: [
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
                checkinBlock(),
                historicBlock(),
                fileBlock(),
                documentBlock(),
                // logoutBlock(),
              ],
            ),
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[900],
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
              icon: new SizedBox(
                child: new IconButton(
                    icon: new Image.asset(
                      "assets/images/inkless-vertical-branca.png",
                      height: 80,
                      width: 100,
                    ),
                    onPressed: () {}),
                width: 60,
                height: 60,
              ),
              title: new Text(
                "",
                style: new TextStyle(fontSize: 0),
              )),
          BottomNavigationBarItem(
              icon: new SizedBox(
                child: new IconButton(
                    color: Colors.white,
                    icon: Icon(
                      Icons.exit_to_app,
                      size: 30,
                    ),
                    onPressed: () {
                      sharedPreferences.clear();
                      sharedPreferences.remove("paciente_id");
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    }),
                width: 60,
                height: 60,
              ),
              title: new Text("",
                  style: TextStyle(fontSize: 0, color: Colors.white)))
        ],
      ),
    );
  }
}
