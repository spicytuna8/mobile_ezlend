import 'package:flutter/material.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/widget/global_function.dart';

class UIYourBalance extends StatelessWidget {
  final double? balance;
  final bool isLoading;
  final String? subTitle;
  final Widget? statusBadge;
  final String? customBalanceText;

  const UIYourBalance({
    Key? key,
    this.balance,
    this.isLoading = false,
    this.subTitle,
    this.statusBadge,
    this.customBalanceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/promo2.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Languages.of(context).loanBalance,
                style: white12w400,
              ),
              if (statusBadge != null) statusBadge!,
            ],
          ),
          const SizedBox(height: 8.0),
          // Balance display
          isLoading || balance == null
              ? const Text(
                  'HKD -',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Gabarito',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                )
              : Text(
                  customBalanceText ?? 'HKD ${GlobalFunction().formattedMoney(balance!)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontFamily: 'Gabarito',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
          const SizedBox(height: 16.0),
          if (subTitle != null)
            Text(
              subTitle!,
              style: white12w400,
            ),
        ],
      ),
    );
  }
}
