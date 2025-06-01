import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {

  // Method to get the current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      // return Position(); // Return statement is commented out
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permissions are denied.');
        // return Position(); // Return statement is commented out
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('Location permissions are permanently denied.');
      // return Position(); // Return statement is commented out
    }

    // Get the current position of the device
    Position position = await Geolocator.getCurrentPosition(
     locationSettings: LocationSettings(accuracy: LocationAccuracy.high)
    );
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setDouble("lat", position.latitude);
    sp.setDouble("long", position.longitude);

    debugPrint('Current Position: Lat: ${position.latitude}, Lng: ${position.longitude}');
    return position; // Return statement is commented out
  }
}