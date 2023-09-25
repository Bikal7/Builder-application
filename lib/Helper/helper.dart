import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  String address = "";
  double? lat;
  double? long;

  StreamSubscription<Position>? _positionStream;

  static backdropFilter(context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
      child: SafeArea(
        child: Stack(
          children: [
            const Center(
              child: SpinKitCircle(color: Colors.blue),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white.withOpacity(0),
            ),
          ],
        ),
      ),
    );
  }

  launchMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final url = "https://www.google.com/maps/search/?api=1&query=$query";
    try{
      await launch(url);
    }catch(e){
      print(e);
    }
  }

  getPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print('Location permissions are denied');
      await Geolocator.requestPermission().then((value) async {
        permission = await Geolocator.checkPermission();
      });
    }
    return permission;
  }
  StreamController<Coordinate> controller = StreamController<Coordinate>();

  Stream<Coordinate> getCoordinateStream() {
    
  try{
       Stream<Position> positionStream = Geolocator.getPositionStream();
    Stream<Coordinate> coordinateStream =
        positionStream.asyncExpand((Position position) async* {
      double lat = position.latitude;
      double long = position.longitude;
      String address = await getAddress(lat, long);
      yield Coordinate(latitude: lat, longitude: long, address: address);
    });

    coordinateStream.listen((Coordinate coordinate) {
      controller.add(coordinate);
    }); 
  }catch(e){
    print(e);
  }


    return controller.stream;
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    address =
        placemarks[3].street! + ", " + placemarks[3].subAdministrativeArea!;
    return address;
  }

  stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    const int earthRadius = 6371;

    double startLatRadians = degreesToRadians(startLat);
    double startLngRadians = degreesToRadians(startLng);
    double endLatRadians = degreesToRadians(endLat);
    double endLngRadians = degreesToRadians(endLng);

    double latDiff = endLatRadians - startLatRadians;
    double lngDiff = endLngRadians - startLngRadians;

    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(startLatRadians) *
            cos(endLatRadians) *
            sin(lngDiff / 2) *
            sin(lngDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }



}

class Coordinate {
  double? latitude, longitude;
  String? address;
  Coordinate({this.latitude, this.longitude, this.address});
}


