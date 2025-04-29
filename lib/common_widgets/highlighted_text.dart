import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final List<String> highlightWords;
  final Color highlightColor;
  final TextStyle? style;
  final Color normalColor;
  const HighlightText({
    super.key,
    required this.text,
    required this.highlightWords,
    this.highlightColor = Colors.red,
    this.style,
    this.normalColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    return RichText(
      text: TextSpan(
        children: words.map((word) {
          final cleanWord = word.replaceAll(RegExp(r'[^\w]'), '');
          final isHighlighted = highlightWords.contains(cleanWord);

          return TextSpan(
            text: '$word ',
            style: style?.copyWith(
              color:
                  isHighlighted ? highlightColor : style?.color ?? normalColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}
