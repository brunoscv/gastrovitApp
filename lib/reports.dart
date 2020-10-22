import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastrovita/services/api_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ReportsPage(),
  ));
}

class ReportsPage extends StatefulWidget {
  final String title = "Laudos Médicos";

  final int id;

  ReportsPage({Key key, this.id}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<dynamic> data;

  @override
  void initState() {
    super.initState();
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
        title: Text(widget.title),
        backgroundColor: Colors.blue,
        actions: <Widget>[],
      ),
      body: Stack(
        children: <Widget>[
          FutureBuilder(
              future: AllSchedulingService.getAllScheduling(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final schedulings = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var flag = schedulings.schedulings[index].checkIn;
                      print(flag);
                      return Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 12.0, 12.0, 0.0),
                              child: Icon(
                                FontAwesomeIcons.folder,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                            Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 20.0, 0.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "NomeDoExame_20200403102143.pdf",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.0,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                )),
                            Divider(
                              height: 10.0,
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: schedulings.schedulings.length,
                  );
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
