import 'dart:async';

import 'package:geolocator/geolocator.dart';

class GeolocationHelper {
  final LocationSettings _locationSettings = const LocationSettings();
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future requestServiceAndPermission() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (_permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  bool checkServiceAndPermission() {
    if (_serviceEnabled) {
      bool hasPermission = _permission != LocationPermission.denied ||
              _permission != LocationPermission.deniedForever ||
              _permission != LocationPermission.unableToDetermine
          ? true
          : false;
      return hasPermission;
    } else {
      return _serviceEnabled;
    }
  }

  /// Subscribe location service status stream.
  ///
  /// [callback] is for handling location service status when *enable* or *disable*.
  void handleServiceStatusStream(Function(ServiceStatus status) callback) =>
      Geolocator.getServiceStatusStream().listen(callback);

  /// Subscribe user position stream.
  ///
  /// [callback] is for handling user position.
  void handlePositionStream(Function(Position? position) callback) =>
      Geolocator.getPositionStream(locationSettings: _locationSettings)
          .listen(callback);
}
