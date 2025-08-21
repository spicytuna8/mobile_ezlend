import 'package:flutter/material.dart';
import 'package:loan_project/helper/languages.dart';

class MainButtonGradient extends StatelessWidget {
  const MainButtonGradient({super.key, this.title, this.onTap, this.width, this.height, this.fontSize});
  final String? title;
  final double? width;
  final double? height;
  final double? fontSize;
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
          padding: EdgeInsets.symmetric(
              horizontal: (width != null && width! < 100) ? 8 : 16,
              vertical: (height != null && height! < 40) ? 6 : 12),
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
                    colors: [Color(0xFFFEA307), Color(0xFFFE7D08)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
          child: Center(
            child: Text(
              title ?? Languages.of(context).continueText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize ?? ((width != null && width! < 100) ? 12 : 14),
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
