import 'package:flutter/material.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/text_helper.dart';

class UIYourBalanceDue extends StatelessWidget {
  final double? balance;
  final bool isLoading;
  final Widget? statusBadge;
  final Widget? paymentDueContent;
  final String? customBalanceText;

  const UIYourBalanceDue({
    Key? key,
    this.balance,
    this.isLoading = false,
    this.statusBadge,
    this.paymentDueContent,
    this.customBalanceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Loan Balance Card (Top)
        Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
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
                  statusBadge ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                isLoading ? 'HKD -' : customBalanceText ?? 'HKD ${balance != null ? _formatMoney(balance!) : '-'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontFamily: 'Gabarito',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),

        // Payment Due Section (Bottom)
        Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xFF252422),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Languages.of(context).paymentDueDate,
                style: white12w400,
              ),
              paymentDueContent ??
                  Text(
                    '--/--/--',
                    style: white12w400,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatMoney(double amount) {
    // Simple money formatting - you can enhance this based on your existing GlobalFunction
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
