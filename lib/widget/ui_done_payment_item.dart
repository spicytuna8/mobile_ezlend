import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/ui_done_payment_status.dart';

class UIDonePaymentItem extends StatelessWidget {
  final DateTime? createdAt;
  final String? amount;
  final int? paymentType;
  final int? status;

  const UIDonePaymentItem({
    Key? key,
    this.createdAt,
    this.amount,
    this.paymentType,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          // Top row - Amount and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HKD ${GlobalFunction().formattedMoney(double.parse(amount ?? '0'))}',
                style: const TextStyle(
                  color: Color(0xFFDFCE34),
                  fontSize: 16,
                  fontFamily: 'Gabarito',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(createdAt ?? DateTime.now()),
                style: const TextStyle(
                  color: Color(0xFF7D8998),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          // Bottom row - Payment method and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                paymentType == 2 ? Languages.of(context).manualBanking : Languages.of(context).wireTransfer,
                style: const TextStyle(
                  color: Color(0xFF7D8998),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIDonePaymentStatus(
                status: status,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
