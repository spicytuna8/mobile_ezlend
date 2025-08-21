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
    Color _getStatusColor(int? status) {
      switch (status) {
        case 2:
          return Colors.green; // paid
        case 3:
          return Colors.red; // rejected
        case 0:
        default:
          return Colors.orange; // pending
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
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
