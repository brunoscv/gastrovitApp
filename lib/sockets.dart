import 'package:adhara_socket_io/manager.dart';
import 'package:adhara_socket_io/socket.dart';
import 'package:flutter/material.dart';

class SocketsPage extends StatefulWidget {
  SocketsPage({Key key}) : super(key: key);

  final String title = "Sockets";

  @override
  _SocketsPageState createState() => _SocketsPageState();
}

class _SocketsPageState extends State<SocketsPage> {
  SocketIOManager manager;
  SocketIO io;

  bool isConnected = false;
  String uri = "https://demo.denarius.digital:6001";

  @override
  void initState() {
    super.initState();
    manager = SocketIOManager();
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

  sendMessage() {
    if (io != null) {
      io.emit("emiteMsg", [
        {"send_id": 13, "msg": "olaaaaaa"}
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the SocketsPage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 26.0,
                  ),
                  button(sendMessage, Icons.send, "1"),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
