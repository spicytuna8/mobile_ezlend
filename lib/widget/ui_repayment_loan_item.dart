import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/status_loan_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/ui_active.dart';
import 'package:loan_project/widget/ui_package_name.dart';

class UIRepaymentLoanItem extends StatelessWidget {
  final DatumLoan loan;

  const UIRepaymentLoanItem({
    Key? key,
    required this.loan,
  }) : super(key: key);

  // Check if a specific loan is overdue
  bool _isLoanOverdue(DatumLoan loan) {
    return StatusHelper.isApproved(loan.status ?? 0) &&
        (StatusLoanHelper.isOverdue(loan.statusloan ?? 0) ||
            (StatusLoanHelper.isActive(loan.statusloan ?? 0) && StatusHelper.isBlacklisted(loan.blacklist ?? 0)));
  }

  // Calculate due date from loan date + return days
  DateTime? _calculateDueDate(DatumLoan loan) {
    if (loan.dateloan != null && loan.returnday != null) {
      return loan.dateloan!.add(Duration(days: loan.returnday!));
    }
    return null;
  }

  // Get status text for a loan
  String _getLoanStatusText(DatumLoan loan, BuildContext context) {
    if (_isLoanOverdue(loan)) {
      return Languages.of(context).overdue;
    } else if (StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.isActive(loan.statusloan ?? 0)) {
      return Languages.of(context).active;
    } else if (StatusHelper.isPending(loan.status ?? 0) && StatusLoanHelper.isActive(loan.statusloan ?? 0)) {
      return Languages.of(context).pending;
    }
    return Languages.of(context).noActive;
  }

  @override
  Widget build(BuildContext context) {
    bool isOverdue = _isLoanOverdue(loan);
    String loanAmount = loan.totalreturn ?? loan.loanamount ?? '0';

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF252422),
          borderRadius: BorderRadius.circular(12),
          border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Leading - Circle Avatar
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: const AssetImage(
              "assets/images/dollar.png",
            ),
          ),
          const SizedBox(width: 16.0),

          // Middle - Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              UIPackageName(
                                packageName: loan.packageName ?? 'Loan Package',
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  'HKD ${GlobalFunction().formattedMoney(double.tryParse(loanAmount) ?? 0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Gabarito',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              UIActive(
                                statusText: _getLoanStatusText(loan, context),
                                isOverdue: isOverdue,
                                borderRadius: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/apply_date.png',
                      width: 14,
                      height: 14,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      loan.dateloan != null ? DateFormat('dd MMM yyyy').format(loan.dateloan!) : 'N/A',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white.withOpacity(0.6),
                          size: 14,
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          _calculateDueDate(loan) != null
                              ? DateFormat('dd MMM yyyy').format(_calculateDueDate(loan)!)
                              : 'N/A',
                          style: TextStyle(
                            color: isOverdue ? Colors.red.withOpacity(0.9) : Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: MainButtonGradient(
                    title: Languages.of(context).viewDetail,
                    height: 40,
                    noPadding: true,
                    onTap: () {
                      // Navigate to loan detail screen
                      context.pushNamed(loanDetail, extra: loan);
                    },
                  ),
                ),
              ],
            ),
          )
        ]));
  }
}
