import 'dart:async';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TestePage(),
  ));
}

class TestePage extends StatefulWidget {
  final String title = "GeoLocalizacao";

  @override
  _TestePageState createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //Position _currentPosition;
  List<dynamic> data;

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

  Future<void> _getCheckinDialog() async {
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
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text('SIM', style: TextStyle(color: Colors.white)),
              onPressed: () {
                _verifyUserLocation();
              },
            ),
          ],
        );
      },
    );
  }

  _verifyUserLocation() async {
    double distance = await getLocation();

    if (distance > 0.2) {
      _errorLocation();
    } else {
      _getStateLocation();
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
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
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
            RaisedButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TestePage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.blue,
          title: Text(widget.title),
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
                                          _getCheckinDialog();
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
              ));
  }
}
