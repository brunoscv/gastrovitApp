import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gastrovita/attendance.dart';
import 'package:gastrovita/exame.dart';
import 'package:gastrovita/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  final String title = "Gastrovita Home";
  @override
  _MyAppState createState() => _MyAppState();
}

enum PageEnum { info, exame, attendance, doctor, home, notifications }

class _MyAppState extends State<MyApp> {
  ObserverList<Function> _listeners = new ObserverList<Function>();
  _onMap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  _onTalk() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ExamePage()));
  }

  _onGo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AttendancePage()));
  }

  Widget button(Function function, IconData icon, String _tag) {
    return FloatingActionButton(
      heroTag: _tag,
      onPressed: function,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.blue,
      child: Icon(
        icon,
        size: 36.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.jpg'),
              radius: 140,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 26.0,
                ),
                button(_onMap, Icons.home, "1"),
                SizedBox(
                  height: 16.0,
                ),
                button(_onTalk, Icons.archive, "2"),
                SizedBox(
                  height: 16.0,
                ),
                button(_onGo, Icons.verified_user, "3"),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
