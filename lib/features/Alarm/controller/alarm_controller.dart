import 'dart:io';

import 'package:alarm_app/constants/text.dart';
import 'package:alarm_app/features/Alarm/model/alarm_model.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
class AlarmAppController extends GetxController {
  DateTime? lastBackPressed;
  final BuildContext context;
  AlarmAppController({required this.context});
  final box = GetStorage();
  final hiveBox = Hive.box('alarmBox');
  RxBool isSoundEnabled = true.obs;
  RxBool isVibrationEnabled = true.obs;
  String formattedAddress = "";
  Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  RxList<AlarmModel> alarms = <AlarmModel>[].obs;

  void pickDateTime() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      is24HourMode: false,
    );
    if (dateTime != null) {
      selectedDateTime.value = dateTime;
    }
  }

  @override
  void onInit() {
    formattedAddress = box.read(AppText.formattedAddress) ?? "";
    loadAlarm();

    super.onInit();
  }

  void loadAlarm() {
    final rawList = hiveBox.get("alarmBox");
    if (rawList == null) {
      alarms.value = [
        AlarmModel(
          id: 0,
          dateTime:
              DateTime.now().add(Duration(days: 0, hours: 2, minutes: 4)).obs,
          isEnabled: false.obs,
        ),
        AlarmModel(
            id: 1,
            dateTime:
                DateTime.now().add(Duration(days: 1, hours: 2, minutes: 4)).obs,
            isEnabled: false.obs),
        AlarmModel(
            id: 2,
            dateTime: DateTime.now().add(Duration(days: 2, hours: 5)).obs,
            isEnabled: false.obs),
      ];
    } else {
      alarms.value = (rawList as List)
          .map((e) => AlarmModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
  }

  Future<void> alarmAddtoList() async {
    try {
      DateTime? dateTime = await showOmniDateTimePicker(
          firstDate: DateTime.now(), context: context);
      if (dateTime != null) {
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          0,
        );
        AlarmModel alarmModel = AlarmModel(
          id: alarms.length + 1,
          dateTime: dateTime.obs,
          isEnabled: true.obs,
        );
        alarms.add(alarmModel);
        await setAlarm(alarmModel);
        hiveBox.put(
          "alarmBox",
          alarms.map((e) => e.toJson()).toList(),
        );
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: e.toString(),
      ));
    }
  }

  Future<void> editExistingAlarmIntoList(int id) async {
    try {
      DateTime? dateTime = await showOmniDateTimePicker(
          firstDate: DateTime.now(), context: context);
      if (dateTime != null) {
        dateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          0,
        );
        alarms[id].dateTime.value = dateTime;
        alarms[id].isEnabled.value = true;

        await setAlarm(alarms[id]);
        hiveBox.put(
          "alarmBox",
          alarms.map((e) => e.toJson()).toList(),
        );
      }
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: e.toString(),
      ));
    }
  }

  Future<bool> setAlarm(AlarmModel alarm) async {
    try {
      await AndroidAlarmManager.oneShotAt(
        alarm.dateTime.value,
        alarm.id,
        alarmCallback,
        alarmClock: true,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      print("Alarm set successfully!");
      return true;
    } catch (e) {
      print("Error setting alarm: $e");
      return false;
    }
  }

  Future<bool> cancelAlarm(int alarmId) async {
    try {
      final result = await AndroidAlarmManager.cancel(alarmId);
      print("Alarm with ID $alarmId cancelled: $result");
      return result;
    } catch (e) {
      print("Error cancelling alarm: $e");
      return false;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> alarmCallback(int id, Map<String, dynamic> params) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    final Box box = await Hive.openBox('alarmBox');

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alarm_channel_id',
      'Alarm Notifications',
      channelDescription: 'Alarm notification channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      'Alarm',
      "Alarm is ringing!",
      platformDetails,
    );

    final rawList = box.get('alarmBox') ?? [];
    final updatedList = (rawList as List).map((e) {
      final alarm = AlarmModel.fromJson(Map<String, dynamic>.from(e));
      if (alarm.id == id) {
        alarm.isEnabled.value = false;
      }
      return alarm.toJson();
    }).toList();

    await box.put('alarmBox', updatedList);
  }

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
}
