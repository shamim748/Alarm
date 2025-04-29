import 'package:alarm/common_widgets/custom_button.dart';
import 'package:alarm/common_widgets/onbording_page.dart';
import 'package:alarm/constants/color.dart';
import 'package:alarm/features/onbording/controller/onbording_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnbordingScreen extends StatelessWidget {
  const OnbordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnbordingController>(builder: (controller) {
      return Scaffold(
          backgroundColor: AppColor.scaffoldBgColor,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              TextButton(
                  onPressed: () {
                    controller.onSkip();
                  },
                  child: Text("Skip",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)))
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: PageView(
                        controller: controller.pageController,
                        children: [
                          SizedBox.expand(
                            child: onboardingPage(
                              image: 'assets/images/morninggif1 1.png',
                              title: 'Sync with Nature’s Rhythm',
                              subtitle:
                                  'Experience a peaceful transition into the evening with an alarm that aligns with the sunset."Your perfect reminder, always 15 minutes before sundown',
                              highlightWords: ['Sync'],
                              normalColor: Colors.white,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox.expand(
                            child: onboardingPage(
                              image: 'assets/images/morning walk gif 1.png',
                              title: 'Sync with Nature’s Rhythm',
                              subtitle:
                                  'Experience a peaceful transition into the evening with an alarm that aligns with the sunset."Your perfect reminder, always 15 minutes before sundown',
                              highlightWords: ['Sync'],
                              normalColor: Colors.white,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox.expand(
                            child: onboardingPage(
                              image: 'assets/images/Mask group.png',
                              title: 'Sync with Nature’s Rhythm',
                              subtitle:
                                  'Experience a peaceful transition into the evening with an alarm that aligns with the sunset."Your perfect reminder, always 15 minutes before sundown',
                              highlightWords: ['Sync'],
                              normalColor: Colors.white,
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitleStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.totalPages,
                      effect: const WormEffect(
                        activeDotColor: AppColor.purpleLight70,
                        dotHeight: 8,
                        dotWidth: 8,
                        type: WormType.thinUnderground,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: customButton(
                        height: 56,
                        width: double.infinity,
                        backgroundColor: AppColor.purpleDark10,
                        text: "Next",
                        onPressed: () async {
                          controller.nextPage();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ));
    });
  }
}
