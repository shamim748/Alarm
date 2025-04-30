import 'package:get/get.dart';

class AlarmModel {
  Rx<DateTime> dateTime;
  RxBool isEnabled;
  int id;
  AlarmModel({
    required this.id,
    required this.dateTime,
    required this.isEnabled,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.value.toIso8601String(),
      'isEnabled': isEnabled.value,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']).obs,
      isEnabled: (json['isEnabled'] as bool).obs,
    );
  }
}
