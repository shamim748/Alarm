import 'package:flutter/material.dart';

Widget customButton({
  required String text,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? textColor,
  double? width,
  double? height,
  double? borderRadius,
  TextStyle? textStyle,
  bool hasIcon = false,
  Widget? icon,
  Color? iconcolor,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      child: hasIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(width: 8),
                icon ?? const SizedBox(),
              ],
            )
          : Text(
              text,
              style: textStyle ??
                  TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                  ),
            ),
    ),
  );
}
