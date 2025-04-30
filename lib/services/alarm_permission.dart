import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermission {
  Future<void> enforceNotificationPermission() async {
    var status = await Permission.notification.status;

    if (!status.isGranted) {
      var requestStatus = await Permission.notification.request();

      while (!requestStatus.isGranted) {
        await Get.dialog(
          AlertDialog(
            title: const Text("Notification Permission Required"),
            content: const Text(
              "To use this app, you must enable notification access. "
              "Please allow it from the settings.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Try Again"),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        status = await Permission.notification.status;
        if (status.isGranted) break;

        requestStatus = await Permission.notification.request();
      }
    }
  }

  Future<bool> requestAlarmScheduleExactAlarmPermissions() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      if (!alarmStatus.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<void> requestPermissions() async {
    var locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      if (locationStatus.isDenied) {
        if (!await Permission.location.request().isGranted) {
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
      } else if (locationStatus.isPermanentlyDenied) {
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
  }
}
