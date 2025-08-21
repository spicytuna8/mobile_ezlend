import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIPackageName extends StatelessWidget {
  final String packageName;

  const UIPackageName({
    Key? key,
    required this.packageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFC7C7C7),
            Color(0xFF717171),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          packageName.isNotEmpty ? packageName : 'Loan Package',
          style: GoogleFonts.inter(
            color: const Color(0xFF292929),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
