import 'package:flutter/material.dart';
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/widget/global_function.dart';

class UIDonePaymentStatus extends StatelessWidget {
  final int? status;

  const UIDonePaymentStatus({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApproved = StatusHelper.isApproved(status ?? 0);
    final String statusText = GlobalFunction().getStatus(status, context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isApproved ? const Color(0xFFE02424) : const Color(0xFF67A353),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
