import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng> getGeoLocationPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return Future.error('DISABLED');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('DENIED');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('PERMANENT_DISABLED');
  }

  var currentPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  var latLong = LatLng(currentPosition.latitude, currentPosition.longitude);
  // _loadAuctions(latLong);
  return latLong;
}

Future<Uint8List> getBytesFromNetwork(String url) async {
  final Uri uri = Uri.parse(url);
  final HttpClient httpClient = HttpClient();
  final HttpClientRequest request = await httpClient.getUrl(uri);
  final HttpClientResponse response = await request.close();
  final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  return bytes;
}

/// Computes the haversine distance (in meters) between two points.
double distanceBetween(LatLng a, LatLng b) {
  const R = 6371000; // Earth's radius in meters
  double dLat = (b.latitude - a.latitude) * (pi / 180);
  double dLon = (b.longitude - a.longitude) * (pi / 180);
  double lat1 = a.latitude * (pi / 180);
  double lat2 = b.latitude * (pi / 180);
  double aVal = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));
  return R * c;
}
