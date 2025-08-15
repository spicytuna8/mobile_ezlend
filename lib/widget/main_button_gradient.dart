import 'package:flutter/material.dart';
import 'package:loan_project/helper/languages.dart';

class MainButtonGradient extends StatelessWidget {
  const MainButtonGradient(
      {super.key, this.title, this.onTap, this.width, this.height});
  final String? title;
  final double? width;
  final double? height;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: width ?? 350,
          height: height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          clipBehavior: Clip.antiAlias,
          decoration: onTap == null
              ? BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                )
              : ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, 1.00),
                    end: Alignment(2, 1),
                    colors: [Color(0xFFFED607), Color(0xFFF77F00)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
          child: Center(
            child: Text(
              title ?? Languages.of(context).continueText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
