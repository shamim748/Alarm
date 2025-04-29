import 'package:alarm/common_widgets/highlighted_text.dart';
import 'package:alarm/constants/color.dart';
import 'package:flutter/material.dart';

Widget onboardingPage({
  required String image,
  required String title,
  required String subtitle,
  List<String> highlightWords = const [],
  Color? highlightColor,
  Color? normalColor,
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
}) {
  return SizedBox.expand(
    child: Column(
      children: [
        Flexible(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Image.asset(
              image,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HighlightText(
                  style: titleStyle,
                  highlightColor: highlightColor ?? AppColor.purpleLight70,
                  text: title,
                  highlightWords: highlightWords),
              const SizedBox(height: 16),
              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: subtitleStyle,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
