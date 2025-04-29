import 'package:flutter/material.dart';

Widget descriptionText(
    {required String description,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color}) {
  return Text(
    description,
    style: TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.white,
    ),
  );
}
