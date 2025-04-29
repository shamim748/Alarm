import 'package:alarm/features/location/controller/location_view_controller.dart';
import 'package:get/get.dart';

class LocationBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LocationViewController());
  }
}
