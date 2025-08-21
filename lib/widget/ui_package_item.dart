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
            width: 1,
            color: isSelected ? const Color(0xFFFED607) : const Color(0xFF252422).withOpacity(0.4),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  gradientColors: isSelected
                      ? [
                          const Color(0xFFFED607),
                          const Color(0xFFD1D5DB),
                        ]
                      : [
                          const Color(0xFFC7C7C7),
                          const Color(0xFF717171),
                        ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              GlobalFunction().formattedMoney(double.parse(package.amount)).toString(),
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : const Color(0xFFD1D5DB).withOpacity(0.4),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
