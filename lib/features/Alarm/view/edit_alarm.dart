import 'package:alarm_app/features/Alarm/controller/alarm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditAlarm extends StatelessWidget {
  const EditAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AlarmAppController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Edit Alarm"),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          children: [
            ListTile(
              title: Text(
                controller.selectedDateTime.value != null
                    ? 'Selected: ${controller.selectedDateTime.value!.toLocal()}'
                    : 'Pick Date & Time',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: controller.pickDateTime,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text("Enable Alarm Sound"),
              value: controller.isSoundEnabled.value,
              onChanged: (value) {
                controller.isSoundEnabled.value = value;
              },
            ),
            SwitchListTile(
              title: Text("Enable Vibration"),
              value: controller.isVibrationEnabled.value,
              onChanged: (value) {
                controller.isVibrationEnabled.value = value;
              },
            ),
            Spacer(),
            ElevatedButton.icon(
              icon: Icon(Icons.alarm),
              label: Text("Save Alarm"),
              onPressed: () {},
            )
          ],
        ),
      );
    });
  }
}
