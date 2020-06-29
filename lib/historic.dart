import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gastrovita/services/api_service.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HistoricPage(),
  ));
}

class HistoricPage extends StatefulWidget {
  final String title = "Histórico de Agendamentos";

  final int id;

  HistoricPage({Key key, this.id}) : super(key: key);

  @override
  _HistoricPageState createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  List<dynamic> data;

  @override
  void initState() {
    super.initState();
  }

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
  return Container(
    padding: EdgeInsets.only(top:120, left:40, right:40),
    child: ListView(
      children: <Widget>[
        SizedBox(
          width:150,
          height:150,
          child: Image.asset("assets/images/wlan.png"),
        ),
          SizedBox(
            height: 20,
          ),
          Text("Verifique suas conexões com a Internet.", style: TextStyle(fontSize: 18, color: Colors.grey), textAlign: TextAlign.center),
          
      ],
    ),
  );
}

Widget _buttonStatus(String flag) {
  if (flag == "Red") {
    return Padding(
      padding: EdgeInsets.all(4),
      child:Badge(
        badgeColor: Colors.red,
        borderRadius: 20,
        shape: BadgeShape.square,
        position: BadgePosition.topRight(right: 15),
        badgeContent: Text(
          'Não Atendido',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        
        ),
      )
    );
  } else if (flag == "Blue") {
    return Padding(
      padding: EdgeInsets.all(4),
      child:Badge(
        badgeColor: Colors.blue,
        borderRadius: 20,
        shape: BadgeShape.square,
        position: BadgePosition.topRight(right: 15),
        badgeContent: Text(
          'Agendado',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        
        ),
      )
    );
  } else if (flag == "Green") {
    return Padding(
      padding: EdgeInsets.all(4),
      child:Badge(
        badgeColor: Colors.green,
        borderRadius: 20,
        shape: BadgeShape.square,
        position: BadgePosition.topRight(right: 15),
        badgeContent: Text(
          'Atendido',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white),
        
        ),
      )
    );
  }
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
                    var time = Jiffy("${schedulings.schedulings[index].timeStartingBooked}", "hh:mm:ss");
                    var timeFormat = time.format("hh:mm");
                    var date = Jiffy( "${schedulings.schedulings[index].dateScheduling}", "yyyy-MM-dd");
                    var dateFormat = date.format("dd/MM/yyyy");
                    var flag = schedulings.schedulings[index].checkIn;
                    print(flag);
                    return Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              radius: 50,
                              child: ClipOval(
                                    child: Image.network( 
                                      'https://gastrovita.inkless.digital/storage/${schedulings.schedulings[index].professionalImage}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5.0, 12.0, 0.0, 0.0),
                            
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "HOSPITAL GASTROVITA",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: Colors.blue
                                    ),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                                  Text(
                                    "Dr.(a) ${schedulings.schedulings[index].professionalName}",
                                    style: const TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold),
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        dateFormat,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                      ),
                                      Expanded(
                                          child: Text(
                                        timeFormat,
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),
                                      ))
                                    ],
                                  ),
                                  const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "CRM-PI 123456",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                                      ),
                                      _buttonStatus(flag),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ),
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
