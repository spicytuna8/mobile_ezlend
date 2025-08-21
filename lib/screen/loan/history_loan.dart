import 'package:flutter/material.dart';
import 'package:loan_project/model/response_get_loan.dart';

import '../../widget/ui_history_loan_item.dart';

class HistoryLoan extends StatefulWidget {
  final List<DatumLoan> data;
  const HistoryLoan({
    super.key,
    required this.data,
  });

  @override
  State<HistoryLoan> createState() => _HistoryLoanState();
}

class _HistoryLoanState extends State<HistoryLoan> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.data.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return UIHistoryLoanItem(
          loanData: widget.data[index],
        );
      },
    );
  }
}
