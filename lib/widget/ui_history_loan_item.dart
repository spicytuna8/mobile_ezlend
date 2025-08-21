import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/ui_package_name.dart';

class UIHistoryLoanItem extends StatelessWidget {
  final DatumLoan loanData;
  final VoidCallback? onTap;

  const UIHistoryLoanItem({
    Key? key,
    required this.loanData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.pushNamed(historyLoanDetail, extra: loanData);
          },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), side: const BorderSide(width: 1, color: Color(0xFF354150))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        UIPackageName(
                          packageName: loanData.packageName ?? '',
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          GlobalFunction().formattedMoney(double.parse(loanData.loanamount ?? '')),
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFED607),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer()
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      loanData.dateloan == null ? '-' : DateFormat('dd MMMM yyyy').format(loanData.dateloan!),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7D8998),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Trailing - Amount and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: loanData.status == 2
                        ? () {
                            GlobalFunction().rejectCodeDialog(context,
                                title: '${Languages.of(context).reason} : ',
                                subtitle: loanData.rejectedCode?[0].content ?? '');
                          }
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusBackgroundColor(),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getStatusText(context),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (loanData.status == 2) ...[
                          const SizedBox(width: 4.0),
                          Image.asset(
                            'assets/icons/ic_info_danger.png',
                            width: 13.6,
                            height: 13.6,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(BuildContext context) {
    // Check if loan is overdue (same logic as background color)
    bool isOverdue = loanData.status == 3 &&
        (loanData.statusloan == 7 ||
            loanData.statusloan == 6 ||
            loanData.statusloan == 8 ||
            (loanData.statusloan == 4 && loanData.blacklist == 9));

    if (isOverdue) {
      return Languages.of(context).overdue;
    } else if (loanData.status == 3 && loanData.statusloan == 4) {
      return Languages.of(context).active;
    } else if (loanData.status == 3 && loanData.statusloan == 5) {
      return Languages.of(context).closed;
    } else if (loanData.status == 2) {
      return Languages.of(context).reject;
    } else if (loanData.status == 10) {
      return Languages.of(context).pendingApproval;
    } else if (loanData.status == 0 || loanData.status == 1) {
      return Languages.of(context).pending;
    } else {
      return Languages.of(context).pending; // Default to pending for other cases
    }
  }

  Color _getStatusBackgroundColor() {
    // Check if loan is overdue (similar to UIActive logic)
    bool isOverdue = loanData.status == 3 &&
        (loanData.statusloan == 7 ||
            loanData.statusloan == 6 ||
            loanData.statusloan == 8 ||
            (loanData.statusloan == 4 && loanData.blacklist == 9));

    if (isOverdue) {
      return Colors.red; // Red background for overdue
    } else if (loanData.status == 3 && loanData.statusloan == 4) {
      return Colors.green; // Green background for active
    } else if (loanData.status == 2) {
      return const Color(0xFFEF233C); // Red background for rejected
    } else if (loanData.status == 3 && loanData.statusloan == 5) {
      return Colors.grey; // Grey background for closed
    } else {
      return const Color(0xFF7D8998); // Default grey background for pending/others
    }
  }
}
