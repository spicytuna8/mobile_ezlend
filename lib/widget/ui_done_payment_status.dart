import 'package:flutter/material.dart';
import 'package:loan_project/widget/global_function.dart';

class UIDonePaymentStatus extends StatelessWidget {
  final int? status;

  const UIDonePaymentStatus({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String statusText = GlobalFunction().getStatus(status, context);

    // Determine color based on status
    Color getStatusColor() {
      switch (status) {
        case 1: // Paid/Approved
          return const Color(0xFF67A353); // Green
        case 2: // Rejected
          return const Color(0xFFE02424); // Red
        case 0: // Pending
        default:
          return const Color(0xFFDFCE34); // Yellow
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: getStatusColor(),
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
