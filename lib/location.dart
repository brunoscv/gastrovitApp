import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gastrovita/models/userlocation.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  LocationPage({Key key}) : super(key: key);

  final String title = "Location";

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // Keep track to user location
  UserLocation _currentLocation;
  Location location = Location();

  //Irá sempre buscar a localização do Usuário.
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted) {
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
                latitude: locationData.latitude,
                longitude: locationData.longitude));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
          latitude: userLocation.latitude, longitude: userLocation.longitude);

      print("Lat: ${userLocation.latitude} - Long: ${userLocation.longitude}");
    } catch (e) {
      print("Não foi possivel recolher a localização do Usuário: $e");
    }
    return _currentLocation;
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
                  buildLocationWidget(),
                  SizedBox(
                    height: 16.0,
                  )
                ],
              ),
            ),
          )
        ]));
  }

  Widget buildLocationWidget() {
    Widget ticketShow = new Center(
      child: new FutureBuilder<UserLocation>(
          future: getLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              /* O texto abaixo recarrega a cada 25 segundos. */
              return new Text(
                  'Lat: ${snapshot.data.latitude}, Log: ${snapshot.data.longitude}',
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
