import 'package:flutter/material.dart';

class UIActive extends StatelessWidget {
  final String statusText;
  final bool isOverdue;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const UIActive({
    Key? key,
    required this.statusText,
    required this.isOverdue,
    this.fontSize = 10.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isOverdue ? Colors.red : const Color(0xFF569235),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
