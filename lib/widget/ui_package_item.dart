import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/ui_package_name.dart';

class UIPackageItem extends StatelessWidget {
  final ItemPackageIndex package;
  final bool isSelected;
  final VoidCallback onTap;

  const UIPackageItem({
    Key? key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: isSelected ? 2 : 1,
            color: isSelected ? const Color(0xFF7C7C7C) : const Color(0xFF252422).withOpacity(0.4),
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/package_bg.png'),
            fit: BoxFit.cover,
          ),
          color: isSelected ? Colors.amber.withOpacity(0.4) : const Color(0xFF252422).withOpacity(0.9),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UIPackageName(
                  packageName: package.name,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Image.asset(
                  isSelected ? 'assets/images/moneybag_active.png' : 'assets/images/moneybag_inactive.png',
                  width: 38,
                  height: 38,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HKD',
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFFD1D5DB).withOpacity(0.4),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      GlobalFunction().formattedMoney(double.parse(package.amount)).toString(),
                      style: GoogleFonts.inter(
                        color: isSelected ? Colors.white : const Color(0xFFD1D5DB).withOpacity(0.4),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
