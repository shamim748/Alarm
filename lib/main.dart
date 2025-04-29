import 'package:alarm/constants/text.dart';
import 'package:alarm/features/location/view/location_view.dart';
import 'package:alarm/features/onbording/controller/onbording_controller.dart';
import 'package:alarm/features/onbording/view/onbording_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();
  MyApp({super.key});

  // This widget is the root of your application.
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
          return onboardingDone ? LocationView() : OnbordingScreen();
        },
      ),
    );
  }
}
