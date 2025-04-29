import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationViewController extends GetxController {
  DateTime? lastBackPressed;
  Future<bool> onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
      lastBackPressed = now;
      Get.snackbar(
        "Press back again to exit",
        "",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return false;
    }
    return true;
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      print("Location permission granted");
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        print("Permission granted after request");
      } else {
        // You can show a dialog here explaining why the permission is needed
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

  Future<void> getCurrentLocation() async {}
}
