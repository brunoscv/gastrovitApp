import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gastrovita/models/tickets.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendancePage(),
  ));
}

class AttendancePage extends StatefulWidget {
  final String title = "Atendimento";

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  Future<Ticket> fetchGet() async {
    final response = await http.get(
        "http://my-json-server.typicode.com/brunoscv/gastrovitaJson/tickets/1");

    final statusCode = response.statusCode;

    if (statusCode != 200 || response.body == null) {
      throw Exception("Error occured : [Status Code : $statusCode]");
    }
    return ticketFromJson(response.body);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      const oneSecond = const Duration(seconds: 25);
      new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.blue,
          title: Text(widget.title),
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          children: <Widget>[
            _buildTile(
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Today\'s OPD',
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 12.0),
                          ),
                          buildTicketWidget(),
                        ],
                      ),
                      Material(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.timeline,
                                color: Colors.white, size: 20.0),
                          )))
                    ]),
              ),
            ),
          ],
          staggeredTiles: [StaggeredTile.extent(2, 90.0)],
        ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Widget buildTicketWidget() {
    Widget ticketShow = new Center(
      child: new FutureBuilder<Ticket>(
          future: fetchGet(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              /* O texto abaixo recarrega a cada 25 segundos. */
              return new Text('${snapshot.data.paciente}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0));
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
    return ticketShow;
  }
}
