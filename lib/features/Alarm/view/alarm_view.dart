import 'package:alarm_app/common_widgets/alarm_box.dart';
import 'package:alarm_app/common_widgets/custom_button.dart';
import 'package:alarm_app/common_widgets/description_text.dart';
import 'package:alarm_app/common_widgets/title_text.dart';
import 'package:alarm_app/constants/color.dart';
import 'package:alarm_app/features/Alarm/controller/alarm_controller.dart';
import 'package:alarm_app/services/alarm_permission.dart';
import 'package:alarm_app/services/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmView extends StatelessWidget {
  const AlarmView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmAppController>(
      init: AlarmAppController(context: context),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.scaffoldBgColor,
          body: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                final shouldExit = await controller.onWillPop();
                if (shouldExit) {
                  SystemNavigator.pop();
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 105),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        title: "Selected Location",
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/icons/location-01.png",
                            height: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: descriptionText(
                              description: controller.formattedAddress,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      customButton(
                        text: "Add Alarm",
                        onPressed: () async {
                          bool val = await AlarmPermission()
                              .requestAlarmScheduleExactAlarmPermissions();
                          if (val == true) {
                            await controller.alarmAddtoList();
                          } else {
                            openAppSettings();
                          }
                        },
                        backgroundColor: AppColor.greyButtonColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: titleText(title: "Alarms", fontSize: 18),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(
                        () {
                          return ListView.builder(
                            itemCount: controller.alarms.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: GestureDetector(
                                  onTap: () async {
                                    controller.editExistingAlarmIntoList(index);
                                  },
                                  child: Obx(
                                    () => CustomAlarmBox(
                                      dateTime: controller
                                          .alarms[index].dateTime.value,
                                      isEnabled: controller
                                          .alarms[index].isEnabled.value,
                                      onToggle: (val) async {
                                        //check if alarm is enabled
                                        bool val = await AlarmPermission()
                                            .requestAlarmScheduleExactAlarmPermissions();
                                        if (val == true) {
                                          if (controller.alarms[index].isEnabled
                                                      .value ==
                                                  false &&
                                              controller
                                                  .alarms[index].dateTime.value
                                                  .isAfter(DateTime.now())) {
                                            controller.alarms[index].isEnabled
                                                .value = true;
                                            controller.hiveBox.put(
                                              "alarmBox",
                                              controller.alarms
                                                  .map((e) => e.toJson())
                                                  .toList(),
                                            );
                                            await controller.setAlarm(
                                                controller.alarms[index]);
                                          } else if (controller.alarms[index]
                                                      .isEnabled.value ==
                                                  false &&
                                              controller
                                                  .alarms[index].dateTime.value
                                                  .isBefore(DateTime.now())) {
                                            //edit alarm
                                            controller
                                                .editExistingAlarmIntoList(
                                                    index);
                                          } else if (controller.alarms[index]
                                                  .isEnabled.value ==
                                              true) {
                                            controller.alarms[index].isEnabled
                                                .value = false;
                                            controller.hiveBox.put(
                                              "alarmBox",
                                              controller.alarms
                                                  .map((e) => e.toJson())
                                                  .toList(),
                                            );
                                            await controller.cancelAlarm(
                                                controller.alarms[index].id);
                                            NotificationService().showNotification(
                                                "Alarm Disabled",
                                                "Your alarm for ${controller.alarms[index].dateTime} has been disabled.");
                                          }
                                        } else {
                                          openAppSettings();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
