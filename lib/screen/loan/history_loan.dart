import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/widget/global_function.dart';

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
  final TransactionBloc _transactionBloc = TransactionBloc();

  @override
  Widget build(BuildContext context) {
    return
        // BlocConsumer<TransactionBloc, TransactionState>(
        //   bloc: _transactionBloc,
        //   listener: (context, state) {
        //     // TODO: implement listener
        //   },
        //   builder: (context, state) {
        //     if (state is GetLoanSuccess) {
        //       return
        ListView.builder(
      itemCount: widget.data.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(historyLoanDetail, extra: widget.data[index]);
          },
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), side: const BorderSide(width: 1, color: Color(0xFF354150))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage: const AssetImage(
                  "assets/images/dollar.png",
                ),
              ),
              title: Text(
                widget.data[index].packageName ?? '',
                style: GoogleFonts.inter(
                  color: const Color(0xFF7D8998),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                widget.data[index].dateloan == null
                    ? '-'
                    : DateFormat('dd MMMM yyyy').format(widget.data[index].dateloan!),
                style: GoogleFonts.inter(
                  color: const Color(0xFF7D8998),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    GlobalFunction().formattedMoney(double.parse(widget.data[index].loanamount ?? '')),
                    style: GoogleFonts.inter(
                      color: const Color(0xFFFED607),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  GestureDetector(
                    onTap: widget.data[index].status == 2
                        ? () {
                            GlobalFunction().rejectCodeDialog(context,
                                title: '${Languages.of(context).reason} : ',
                                subtitle: widget.data[index].rejectedCode?[0].content ?? '');
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Text('Informasi'),
                            //       content: Text(widget.data[index]
                            //               .rejectedCode?[0].content ??
                            //           ''),
                            //       actions: <Widget>[
                            //         TextButton(
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //           child: Text('Tutup'),
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          }
                        : null,
                    child: SizedBox(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.data[index].statusloan == 4
                                ? Languages.of(context).active
                                : widget.data[index].status == 3 && widget.data[index].statusloan == 5
                                    ? Languages.of(context).closed
                                    : widget.data[index].status == 2
                                        ? Languages.of(context).reject
                                        : widget.data[index].status == 10
                                            ? Languages.of(context).pendingApproval
                                            : widget.data[index].status == 0 ||
                                                    widget.data[index].status == 1 ||
                                                    widget.data[index].status == 10
                                                ? Languages.of(context).pending
                                                : Languages.of(context).overdue,
                            style: GoogleFonts.inter(
                              color: widget.data[index].status == 2 ? const Color(0xFFEF233C) : const Color(0xFF7D8998),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          widget.data[index].status == 2
                              ? Image.asset(
                                  'assets/icons/ic_info_danger.png',
                                  width: 13.6,
                                  height: 13.6,
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    // } else if (state is GetLoanError) {
    //   return MainButtonGradient(
    //     title: 'Try Again',
    //     onTap: () {
    //       _transactionBloc.add(const GetLoanEvent());
    //     },
    //   );
    // } else {
    //   return const Center(
    //     child: RefreshProgressIndicator(),
    //   );
    // }
    //   },
    // );
  }
}
