import 'package:alarm_app/common_widgets/custom_button.dart';
import 'package:alarm_app/common_widgets/description_text.dart';
import 'package:alarm_app/common_widgets/title_text.dart';
import 'package:alarm_app/constants/color.dart';
import 'package:alarm_app/constants/text.dart';
import 'package:alarm_app/features/Alarm/view/alarm_view.dart';
import 'package:alarm_app/features/location/controller/alarm_bindings.dart';
import 'package:alarm_app/features/location/controller/location_view_controller.dart';
import 'package:alarm_app/helpers/helpers.dart';
import 'package:alarm_app/services/alarm_permission.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBgColor,
      body: GetBuilder<LocationViewController>(
        init: LocationViewController(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      titleText(title: "Welcome! Your Personalized Alarm"),
                      const SizedBox(height: 16),
                      descriptionText(
                        description:
                            "Allow us to sync your sunset alarm based on your location.",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/images/morning2-transformed 1.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: customButton(
                          hasIcon: true,
                          height: 56,
                          text: "Use current Location",
                          icon: Image.asset(
                            "assets/icons/location-05.png",
                            height: 20,
                          ),
                          onPressed: () async {
                            await controller.requestLocationPermission();
                            await controller.getCurrentLocation();
                          },
                          backgroundColor: AppColor.greyButtonColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: customButton(
                          height: 56,
                          text: "Home",
                          onPressed: () async {
                            if (controller.box.read(AppText.latitude) != null ||
                                controller.box.read(AppText.longitude) !=
                                    null ||
                                Helpers().isFormattedAddress(controller.box
                                        .read(AppText.formattedAddress)) ==
                                    true) {
                              await AlarmPermission()
                                  .enforceNotificationPermission();
                              Get.off(const AlarmView(),
                                  binding: AlarmBindings());
                            } else {
                              Get.snackbar(
                                  backgroundColor: Colors.redAccent,
                                  "Error",
                                  "Please select a location");
                            }
                          },
                          backgroundColor: AppColor.greyButtonColor,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
