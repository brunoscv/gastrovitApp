import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ExamePage(),
  ));
}

class ExamePage extends StatefulWidget {
  final String title = "Resultados de Exames";

  @override
  _ExamePageState createState() => _ExamePageState();
}

class _ExamePageState extends State<ExamePage> {
  List<dynamic> data;

  Future<String> getData() async {
    // var url = "https://jsonplaceholder.typicode.com/todos";
    var url = "https://demo.denarius.digital/api/customers/10";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text('Endogastrite2245223.pdf'),
              subtitle: Text("14kb"),
              trailing: Icon(Icons.file_download),
              onTap: () {
                print('horse');
              },
            ),
          ],
        ).toList(),
      ),
    );
  }
}
