import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GeolocationPage(),
  ));
}

class GeolocationPage extends StatefulWidget {
  final String title = "GeoLocalizacao";

  @override
  _GeolocationPageState createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  //Position _currentPosition;

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
        userLocationLatitude,
        userLocationLongitude);

    return distanceInMeters;
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
                          buildLocationWidget(),
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

  Widget buildLocationWidget() {
    Widget locationShow = new Center(
      child: new FutureBuilder<dynamic>(
          future: getLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              /* O texto abaixo recarrega a cada 25 segundos. */
              return new Text('${snapshot.data}',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.0));
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
    return locationShow;
  }
}
