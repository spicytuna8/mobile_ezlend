import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/repayment/repayment_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';

class DoneRepayment extends StatefulWidget {
  const DoneRepayment({
    super.key,
    required RepaymentBloc repaymentBloc,
    required this.loanpackgeid,
  }) : _repaymentBloc = repaymentBloc;

  final RepaymentBloc _repaymentBloc;
  final int loanpackgeid;

  @override
  State<DoneRepayment> createState() => _DoneRepaymentState();
}

class _DoneRepaymentState extends State<DoneRepayment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepaymentBloc, RepaymentState>(
      bloc: widget._repaymentBloc,
      listener: (context, state) {
        if (state is GetListPaymentError) {
          GlobalFunction().allDialog(context, title: state.message);
        } else if (state is GetListPaymentSuccess) {
          // GlobalFunction().allDialog(context, title: state.message);
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is GetListPaymentLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetListPaymentSuccess) {
          // Simulate 10 items for testing
          return Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF354150)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 10, // Simulate 10 items
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                // Simulate different payment amounts and dates
                final amounts = [1500.0, 2200.0, 1800.0, 3000.0, 2500.0, 1200.0, 2800.0, 1900.0, 2100.0, 1600.0];
                final dates = [
                  DateTime.now().subtract(Duration(days: index * 7)),
                  DateTime.now().subtract(Duration(days: index * 7 + 1)),
                  DateTime.now().subtract(Duration(days: index * 7 + 2)),
                  DateTime.now().subtract(Duration(days: index * 7 + 3)),
                  DateTime.now().subtract(Duration(days: index * 7 + 4)),
                  DateTime.now().subtract(Duration(days: index * 7 + 5)),
                  DateTime.now().subtract(Duration(days: index * 7 + 6)),
                  DateTime.now().subtract(Duration(days: index * 7 + 7)),
                  DateTime.now().subtract(Duration(days: index * 7 + 8)),
                  DateTime.now().subtract(Duration(days: index * 7 + 9)),
                ];
                final paymentTypes = [
                  2,
                  1,
                  2,
                  1,
                  2,
                  1,
                  2,
                  1,
                  2,
                  1
                ]; // Alternate between manual banking and wire transfer
                final statuses = [1, 1, 0, 1, 1, 0, 1, 1, 0, 1]; // Mix of approved and pending

                return Column(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          Languages.of(context).payment,
                          style: white16w600,
                        ),
                        subtitle: Text(
                          DateFormat('dd MMMM yyyy').format(dates[index]),
                          style: const TextStyle(
                            color: Color(0xFF7D8998),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(GlobalFunction().formattedMoney(amounts[index]), style: white16w600),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              paymentTypes[index] == 2
                                  ? '${Languages.of(context).manualBanking} - ${GlobalFunction().getStatus(statuses[index], context)}'
                                  : '${Languages.of(context).wireTransfer} - ${GlobalFunction().getStatus(statuses[index], context)}',
                              style: TextStyle(
                                color: StatusHelper.isApproved(statuses[index]) ? Colors.red : const Color(0xFF67A353),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )),
                  ],
                );
              },
            ),
          );
        } else {
          return MainButtonGradient(
            title: Languages.of(context).tryAgain,
            onTap: () {
              widget._repaymentBloc.add(GetListPaymentEvent(loanpackageid: widget.loanpackgeid.toString()));
            },
          );
        }
      },
    );
  }
}
