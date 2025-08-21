import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/languages.dart';

class UISeeMore extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? customText;

  const UISeeMore({
    Key? key,
    this.onPressed,
    this.customText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = customText ?? Languages.of(context).seeMore;

    if (onPressed != null) {
      // Clickable version (TextButton)
      return TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: const Color(0xff9E9E9E),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      // Static text version
      return Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: const Color(0xFF7D8998),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }
}
