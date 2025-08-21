import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIPackageName extends StatelessWidget {
  final String packageName;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const UIPackageName({
    Key? key,
    required this.packageName,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: gradientBegin ?? Alignment.centerLeft,
          end: gradientEnd ?? Alignment.centerRight,
          colors: gradientColors ??
              [
                const Color(0xFFC7C7C7),
                const Color(0xFF717171),
              ],
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          packageName.isNotEmpty ? packageName : 'Loan Package',
          style: GoogleFonts.inter(
            color: const Color(0xFF292929),
            fontSize: fontSize ?? 12,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
