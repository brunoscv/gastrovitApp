import 'dart:async';
import 'package:location/location.dart';
import '../models/userlocation.dart';

class LocationService {
  // Keep track to user location
  UserLocation _currentLocation;

  Location location = Location();

  //Irá sempre buscar a localização do Usuário.
  StreamController<UserLocation> _locationController =
      StreamController<UserLocation>.broadcast();

  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {
    location.requestPermission().then((granted) {
      if (granted != null) {
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
    } catch (e) {
      print("Não foi possivel recolher a localização do Usuário: $e");
    }
    return _currentLocation;
  }
}
