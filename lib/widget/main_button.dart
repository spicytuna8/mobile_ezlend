import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/color_helper.dart';

class MainButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color? color;
  final double? elevation;
  final Color? titleColor;
  final Widget? child;
  final double? radius;
  final BorderSide? side;
  const MainButton({
    super.key,
    this.title,
    this.onTap,
    this.radius,
    this.height,
    this.side,
    this.elevation,
    this.width,
    this.child,
    this.color,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation ?? 1,
            backgroundColor:
                onTap == null ? const Color(0xFFECECEC) : color ?? baseColor,
            shape: RoundedRectangleBorder(
              side: side ?? BorderSide.none,
              // Change your radius here
              borderRadius: BorderRadius.circular(radius ?? 4),
            ),
          ),
          onPressed: onTap,
          child: child ??
              Text(
                title ?? '',
                style: GoogleFonts.roboto(
                    color: onTap == null
                        ? const Color(0xFFA0AEBA)
                        : titleColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              )),
    );
  }
}
