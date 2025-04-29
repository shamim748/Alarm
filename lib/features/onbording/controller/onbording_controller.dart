import 'dart:async';

import 'package:alarm/constants/text.dart';
import 'package:alarm/features/location/bindings/location_bindings.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../location/view/location_view.dart';

class OnbordingController extends GetxController {
  final box = GetStorage();

  PageController pageController = PageController();
  Timer? timer;
  final int totalPages = 3;
  Future<void> nextPage() async {
    box.write(AppText.onbordingDone, true);
    if (pageController.page!.toInt() == 2) {
      Get.off(() => const LocationView(), binding: LocationBindings());
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  Future<void> onSkip() async {
    box.write(AppText.onbordingDone, true);
    //Get.off(() => const LocationView(), binding: LocationBindings());
  }

  void _startAutoPageChange() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients) {
        int nextPage = pageController.page!.round() + 1;
        if (nextPage >= totalPages) {
          nextPage = 0;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onInit() {
    _startAutoPageChange();
    super.onInit();
  }
}
