import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gastrovita/main.dart';
import 'package:gastrovita/services/api_service.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _cpf;
  String _dataNasc;
  String _errorMessage;

  bool _isLoading;

  var maskCpfFormatter = new MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var maskDateFormatter = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  Future<void> _erroLogin() async {
    setState(() {
      _isLoading = false;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Confira seus dados ou acesso à Internet!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('TENTAR NOVAMENTE',
                  style: TextStyle(color: Colors.blue, fontFamily: "OpenSans")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void validateUsers() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        _cpf = maskCpfFormatter.getUnmaskedText();
        final dataNascFormated =
            Jiffy(_dataNasc, "dd/mm/yyyy").format("yyyy-mm-dd");
        final userData =
            await AuthorizationUsers.getUsers(_cpf, dataNascFormated);
        if (userData == null) {
          setState(() {
            _isLoading = false;
          });
          _erroLogin();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Users(_cpf, dataNascFormated)));
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget headerLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            "assets/images/inkless-vertical-branca.png",
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
            width: 100.0,
            height: 100.0,
          ),
        ),
      ],
    );
  }

  TextEditingController cpfController = new TextEditingController();
  TextEditingController dataNascController = new TextEditingController();

  Widget _inputCPF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('CPF',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: cpfController,
            inputFormatters: [maskCpfFormatter],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                contentPadding: EdgeInsets.all(20.0),
                prefixIcon: Icon(
                  Icons.credit_card,
                  color: Colors.white,
                ),
                hintText: 'Ex: 123.456.789-00',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                ),
                errorStyle: TextStyle(fontSize: 11.0)),
            validator: (value) =>
                value.isEmpty ? "CPF não pode ser nulo!" : null,
            onSaved: (value) => _cpf = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget _inputDataNasc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Data de Nascimento',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
        SizedBox(height: 10.0),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            controller: dataNascController,
            inputFormatters: [maskDateFormatter],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
               
                fillColor: Colors.white,
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0)),
                contentPadding: EdgeInsets.all(20.0),
                prefixIcon: Icon(
                  Icons.today,
                  color: Colors.white,
                ),
                hintText: 'Ex: 99/99/9999',
                hintStyle: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'OpenSans',
                )),
            validator: (value) =>
                value.isEmpty ? "Data de Nascimento não pode ser nula!" : null,
            onSaved: (value) => _dataNasc = value.trim(),
          ),
        ),
      ],
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300,
            fontFamily: "OpenSans"),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showCircularProgress() {
    return SizedBox(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF527DAA))),
      height: 25.0,
      width: 25.0,
    );
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[300],
                  Colors.blue[400],
                  Colors.blue[800],
                  Colors.blue[900],
                ],
                stops: [0.1, 0.5, 0.7, 0.9],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 60.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    headerLogin(),
                    SizedBox(height: 30.0),
                    _inputCPF(),
                    SizedBox(height: 30.0),
                    _inputDataNasc(),
                    SizedBox(height: 50.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SizedBox.expand(
                        child: FlatButton(
                          onPressed: validateUsers,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'ENTRAR',
                                style: TextStyle(
                                  color: Color(0xFF527DAA),
                                  letterSpacing: 1.5,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "OpenSans",
                                ),
                              ),
                              _isLoading
                                  ? _showCircularProgress()
                                  : Icon(Icons.arrow_forward_ios,
                                      color: Color(0xFF527DAA)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Users extends StatefulWidget {
  final _cpf;
  final data;

  Users(this._cpf, this.data);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final _formKey = new GlobalKey<FormState>();
  String _errorMessage;
  bool _isLoading;

  String _firebaseToken;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    this.iniciarFirebaseListeners();
  }

   void iniciarFirebaseListeners() {
    if (Platform.isIOS) requisitarPermissoesParaNotificacoesNoIos();

    _firebaseMessaging.getToken().then((token) {
      
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('mensagem recebida $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void requisitarPermissoesParaNotificacoesNoIos() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  _makePatchRequest(int userId, String token) async {
   
    String url = "https://gastrovita.inkless.digital/api/inklessapp/update/customer";
    Map<String, String> headers = {"Content-type": "application/json; charset=UTF-8"};
    String json = '{"id": "$userId", "device_id": "$token", "token_id": "$token"}';
    try {
      Response response = await put(url, headers: headers, body: json);
      int statusCode = response.statusCode;
      String body = response.body;
      print(body);
      print(statusCode);
      
    } catch (e) {
       print('Error: $e');
    }
  }

  _validateAndSubmit(int id) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
        sharedPreferences.setInt("paciente_id", id);
        _firebaseMessaging.getToken().then((token) {
        _makePatchRequest(id, token);
      });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MainPage()),
            (Route<dynamic> route) => false);
        setState(() {
          _isLoading = false;
        });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _formKey.currentState.reset();
      });
    }
  }

  Widget footerSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top:10),
        child: Center(
          child: Image.asset(
            "assets/images/inkless-vertical-branca.png",
            fit: BoxFit.fitWidth,
            alignment: Alignment.bottomLeft,
            width: 120.0,
            height: 120.0,
          ),
        ),)
        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        title: Text("Selecione um Usuário"),
        backgroundColor: Colors.blue,
        actions: <Widget>[],
      ),
      //bottomSheet: ,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom:37.0),
            child: Stack(
              children: <Widget>[
                FutureBuilder(
                  future: AuthorizationUsers.getUsers(widget._cpf, widget.data),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final usuarios = snapshot.data;
                      return DecoratedBox(
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
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            var date = Jiffy("${usuarios.data[index].birth}", "yyyy-MM-dd");
                            var dateFormat = date.format("dd/MM/yyyy");
                            var image = (usuarios.data[index].image != null) ? "https://gastrovita.inkless.digital/storage/${usuarios.data[index].image}" : "https://pngimage.net/wp-content/uploads/2018/05/default-user-profile-image-png-7.png";
                            var phone = (usuarios.data[index].cel != null) ? "${usuarios.data[index].cel}" : "TELEFONE NÃO CADASTRADO";
                            return Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(10.0,10.0,10.0,0),
                                  height: 200,
                                  width: double.maxFinite,
                                  child: Card(
                                    elevation: 5,
                                    child: InkWell(
                                      onTap:() {
                                        _validateAndSubmit(usuarios.data[index].id);
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10, top: 5),
                                            child: Column(
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    Center(
                                                      child: CircleAvatar(
                                                        radius: 50,
                                                        backgroundImage: NetworkImage(
                                                          image,
                                                        ),
                                                      )
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ]
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text("${usuarios.data[index].name}", style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold))
                                                    )
                                                  ]
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context).textTheme.body1,
                                                      children: [
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                            child: Icon(Icons.cake, color: Colors.blue[600],),
                                                          ),
                                                        ),
                                                        TextSpan(text: '$dateFormat', style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  )
                                                  ]
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                   RichText(
                                                    text: TextSpan(
                                                      style: Theme.of(context).textTheme.body1,
                                                      children: [
                                                        WidgetSpan(
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                            child: Icon(Icons.phone, color: Colors.blue[600],),
                                                          ),
                                                        ),
                                                        TextSpan(text: '${usuarios.data[index].cel}', style: TextStyle(color: Colors.blue[600], fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  )
                                                    
                                                  ]
                                                )
                                              ]
                                            )
                                          )
                                        ]
                                      ),
                                    )
                                  ),
                                ),
                              ],
                              
                            );
                          },
                          itemCount: usuarios.data.length,
                          shrinkWrap: true,
                        )
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                ),
              ],
            ),
          ),
          new Positioned(
              child: new Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(top:5.0),
                  height: 40.0,
                  width: double.maxFinite,
                  color: Colors.blue[900],
                  child: Image.asset("assets/images/inkless-vertical-branca.png"),
                )
              ),
            )
          
        ],
      ),
    );
  }
}
