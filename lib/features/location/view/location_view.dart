import 'package:alarm/common_widgets/custom_button.dart';
import 'package:alarm/common_widgets/description_text.dart';
import 'package:alarm/common_widgets/title_text.dart';
import 'package:alarm/constants/color.dart';
import 'package:alarm/features/location/controller/location_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocationViewController locationViewController =
        Get.put(LocationViewController());
    return Scaffold(
      backgroundColor: AppColor.scaffoldBgColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            final shouldExit = await locationViewController.onWillPop();
            if (shouldExit) {
              SystemNavigator.pop();
            }
          }
        },
        child: GetBuilder<LocationViewController>(
          builder: (controller) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    titleText(title: "Welcome! Your Personalized Alarm"),
                    const SizedBox(height: 16),
                    descriptionText(
                        description:
                            "Allow us to sync your sunset alarm based on your location."),
                    Image.asset("assets/images/morning2-transformed 1.png"),
                    customButton(
                        hasIcon: true,
                        height: 56,
                        text: "Use current Location",
                        icon: Image.asset(
                          "assets/icons/location-05.png",
                          height: 20,
                        ),
                        onPressed: () async {
                          await locationViewController
                              .requestLocationPermission();
                        },
                        backgroundColor: AppColor.greyButtonColor),
                    const SizedBox(height: 8),
                    customButton(
                        height: 56,
                        text: "Home",
                        onPressed: () {},
                        backgroundColor: AppColor.greyButtonColor),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
