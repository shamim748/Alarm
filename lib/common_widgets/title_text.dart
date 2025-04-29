import 'package:flutter/material.dart';

Widget titleText(
    {required String title,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color}) {
  return Text(
    title,
    style: TextStyle(
      fontSize: fontSize ?? 34,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Colors.white,
    ),
  );
}
