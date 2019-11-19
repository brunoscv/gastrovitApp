import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ErrorPage(),
  ));
}

//Return the list with Client Information
class ErrorPage extends StatefulWidget {
  final String title = "Desculpe o transtorno!";

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
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
            backgroundImage: AssetImage('assets/images/error.png'),
            radius: 60,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black45,
            ),
            child: Text(
              "Erro",
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
              top: 55.0, right: 8.0, bottom: 8.0, left: 8.0),
          child: ListView(
            children: [
              Center(child: _buildStack()),
              Card(
                //                           <-- Card widget
                child: ListTile(
                  leading: Icon(Icons.announcement),
                  title: Text(
                      "Infelizmente não foi possível concluir o seu CHECKIN. Por favor verifique o horário da sua consulta ou certifique-se de estar próximo ao local da consulta. Obrigado"),
                  contentPadding: EdgeInsets.all(12.0),
                ),
              ),
            ],
          ),
        ));
  }
}
