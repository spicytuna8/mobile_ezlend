import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainOutlinedButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color? color;
  final double? elevation;
  final Color? titleColor;
  final Color? borderColor;
  final Widget? child;
  final double? radius;
  final BorderSide? side;
  const MainOutlinedButton({
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
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            elevation: elevation ?? 1,
            backgroundColor: color ?? Colors.white,
            side: BorderSide(color: borderColor ?? Color(0xFF037F0C), width: 1),
            shape: RoundedRectangleBorder(
              // Change your radius here
              borderRadius: BorderRadius.circular(radius ?? 0),
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
