// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/widget/global_function.dart';

class HistoryLoanDetail extends StatefulWidget {
  final DatumLoan data;
  const HistoryLoanDetail({Key? key, required this.data}) : super(key: key);

  @override
  State<HistoryLoanDetail> createState() => _HistoryLoanDetailState();
}

class _HistoryLoanDetailState extends State<HistoryLoanDetail> {
  TransactionBloc transactionBloc = TransactionBloc();

  @override
  void initState() {
    transactionBloc.add(CheckLoanEvent(packageId: widget.data.id.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      appBar: AppBar(
        centerTitle: true,
        title: Text(Languages.of(context).historyLoan),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Center(
                child: Text(
                  Languages.of(context).historyLoanOf,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD1D5DB),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Center(
                child: Text(
                  GlobalFunction().formattedMoney(double.parse(widget.data.loanamount ?? '0')),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 45.0,
              ),
              Text(
                Languages.of(context).loanBalance,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Card(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(width: 1, color: Color(0xFF354150))),
                child: ListTile(
                  title: Text(
                    Languages.of(context).loanBalance,
                    style: GoogleFonts.signika(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    Languages.of(context).remainingBalance,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7D8998),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 8.0,
                        ),
                        BlocConsumer<TransactionBloc, TransactionState>(
                          bloc: transactionBloc,
                          listener: (context, state) {
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            if (state is CheckLoanLoading) {
                              return const Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            } else if (state is CheckLoanSuccess) {
                              return Text(
                                state.data.statusbalance == "Balance" || state.data.data?.statusbalance == 'Balance'
                                    ? 0.toString()
                                    : GlobalFunction().formattedMoney((state.data.notbeenpaidof?.toDouble() ??
                                        double.parse(state.data.data?.totalmustbepaid is int
                                            ? state.data.data?.totalmustbepaid.toString()
                                            : state.data.data?.totalmustbepaid ?? widget.data.loanamount.toString()))),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            } else {
                              return Text(
                                '',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          Languages.of(context).unpaid,
                          style: GoogleFonts.inter(
                            color: const Color(0xFFD92037),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22.0,
              ),
              Text(
                Languages.of(context).doneRepayment,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              ListView.builder(
                itemCount: widget.data.loanPackageDetails?.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(width: 1, color: Color(0xFF354150))),
                    child: ListTile(
                      title: Text(
                        Languages.of(context).payment,
                        style: GoogleFonts.signika(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy').format(widget.data.loanPackageDetails![index].createdAt!),
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
                            GlobalFunction()
                                .formattedMoney(double.parse(widget.data.loanPackageDetails?[index].amount ?? '0')),
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            '${GlobalFunction().getBankInfo(widget.data.loanPackageDetails?[index].bankinfo, context)} - ${GlobalFunction().getStatusDetail(widget.data.loanPackageDetails?[index].status, context)}',
                            style: GoogleFonts.inter(
                              color: widget.data.loanPackageDetails?[index].status == 3
                                  ? Colors.red
                                  : const Color(0xFF67A353),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
