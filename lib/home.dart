import 'package:flutter/material.dart';
import 'package:gastrovita/attendance.dart';
import 'package:gastrovita/error.dart';
import 'package:gastrovita/sockets.dart';
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

enum PageEnum { info, exame, attendance, doctor, home, notifications, sockets }

class _HomePageState extends State<HomePage> {
  List<dynamic> data;

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
      case PageEnum.sockets:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SocketsPage()));
        break;
      default:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
    }
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

  Future<void> _neverSatisfied() async {
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ErrorPage()));
              },
            ),
            RaisedButton(
              child: Text('SIM', style: TextStyle(color: Colors.white)),
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

  // @override
  // void initState() {
  //   this.getData();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         appBar: AppBar(
  //           title: Text(widget.title),
  //           backgroundColor: Colors.purple,
  //           bottom: TabBar(
  //             tabs: [
  //               Text(" CONSULTAS "),
  //               Text(" CHECK-IN "),
  //             ],
  //           ),
  //         ),
  //         body: TabBarView(
  //           children: [
  //             HomePage(),
  //             Icon(Icons.directions_transit),
  //             Icon(Icons.directions_bike),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    this.getData();
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
              const PopupMenuItem<PageEnum>(
                value: PageEnum.doctor,
                child: Text('Médico'),
              ),
              const PopupMenuItem<PageEnum>(
                value: PageEnum.notifications,
                child: Text('Notificacoes'),
              ),
              const PopupMenuItem<PageEnum>(
                value: PageEnum.sockets,
                child: Text('Sockets'),
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
                                        _neverSatisfied();
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
