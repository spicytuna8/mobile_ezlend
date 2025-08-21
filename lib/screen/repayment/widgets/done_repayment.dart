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
          return Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0xFF354150)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: ListView.separated(
              itemCount: state.data.data!.length,
              physics: const ScrollPhysics(),
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  color: Colors.grey,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          Languages.of(context).payment,
                          style: white16w600,
                        ),
                        subtitle: Text(
                          DateFormat('dd MMMM yyyy').format(state.data.data![index].createdAt ?? DateTime.now()),
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
                            Text(GlobalFunction().formattedMoney(double.parse(state.data.data?[index].amount ?? '0')),
                                style: white16w600),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              state.data.data?[index].paymentType == 2
                                  ? '${Languages.of(context).manualBanking} - ${GlobalFunction().getStatus(state.data.data?[index].status, context)}'
                                  : '${Languages.of(context).wireTransfer} - ${GlobalFunction().getStatus(state.data.data?[index].status, context)}',
                              style: TextStyle(
                                color: StatusHelper.isApproved(state.data.data?[index].status ?? 0)
                                    ? Colors.red
                                    : const Color(0xFF67A353),
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
