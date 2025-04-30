import 'package:alarm_app/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationViewController extends GetxController {
  final box = GetStorage();

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
      } else {
        Get.dialog(
          AlertDialog(
            title: Text("Location Permission"),
            content: Text("This app needs location access to work properly."),
            actions: [
              TextButton(
                child: Text("Grant"),
                onPressed: () {
                  openAppSettings();
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: Text("Location Permission"),
          content: Text(
              "Location permission is permanently denied. Please enable it from settings."),
          actions: [
            TextButton(
              child: Text("Open Settings"),
              onPressed: () {
                openAppSettings();
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<Position?> getCurrentLocation() async {
    try {
      if (await Permission.location.request().isGranted) {
        final LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );

        Position position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);
        box.write(AppText.latitude, position.latitude);
        box.write(AppText.longitude, position.longitude);
        formattedAddress(position.latitude, position.longitude).then((address) {
          box.write(AppText.formattedAddress, address);
        });

        return position;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String> formattedAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return '${place.name}, ${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        return 'Address not found';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}
