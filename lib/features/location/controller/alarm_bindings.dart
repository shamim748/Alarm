import 'package:alarm_app/features/Alarm/controller/alarm_controller.dart';
import 'package:get/get.dart';

class AlarmBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AlarmAppController(context: Get.context!));
  }
}
