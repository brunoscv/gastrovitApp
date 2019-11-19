import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InfoPage(),
  ));
}

//Return the list with Client Information
class InfoPage extends StatefulWidget {
  final String title = "Informações";

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  List<dynamic> data;

  Future<String> getData() async {
    var url = "https://jsonplaceholder.typicode.com/todos";

    // Await the http get response, then decode the json-formatted responce.
    http.Response response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    this.setState(() {
      data = convert.jsonDecode(response.body);
    });
    print(data);
  }

  @override
  void initState() {
    this.getData();
  }

  String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';

  Widget _buildStack() => Stack(
        alignment: const Alignment(0.6, 0.6),
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.jpeg'),
            radius: 60,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Text(
              "ABDALA",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          margin: const EdgeInsets.only(
              top: 25.0, right: 8.0, bottom: 8.0, left: 8.0),
          child: ListView(
            children: [
              Center(child: _buildStack()),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text("ABDALA JORGE CURY FILHO"),
                onTap: () {
                  print('horse');
                },
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard),
                title: Text("306.709.343-72"),
                onTap: () {
                  print('horse');
                },
              ),
              ListTile(
                leading: Icon(Icons.cake),
                title: Text("15/11/1967"),
                onTap: () {
                  print('horse');
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_phone),
                title: Text("32233208"),
                onTap: () {
                  print('horse');
                },
              ),
              ListTile(
                leading: Icon(Icons.contact_mail),
                title: Text("null"),
                onTap: () {
                  print('horse');
                },
              ),
              ListTile(
                leading: Icon(Icons.location_city),
                title: Text("TERESINA"),
                onTap: () {
                  print('horse');
                },
              ),
            ],
          ),
        ));
  }
}
