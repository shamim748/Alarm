import 'package:alarm_app/constants/text.dart';
import 'package:alarm_app/features/Alarm/view/alarm_view.dart';

import 'package:alarm_app/features/location/view/location_view.dart';
import 'package:alarm_app/features/onbording/controller/onbording_controller.dart';
import 'package:alarm_app/features/onbording/view/onbording_screen.dart';
import 'package:alarm_app/services/notification.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await AndroidAlarmManager.initialize();
  final notificationService = NotificationService();
  await notificationService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Hive.initFlutter();
  await Hive.openBox('alarmBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool onboardingDone = box.read(AppText.onbordingDone) ?? false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alarm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GetBuilder<OnbordingController>(
        init: OnbordingController(),
        builder: (controller) {
          if (onboardingDone &&
              box.read(AppText.latitude) != null &&
              box.read(AppText.longitude) != null) {
            return AlarmView();
          } else if (onboardingDone) {
            return LocationView();
          }
          return OnbordingScreen();
        },
      ),
    );
  }
}
