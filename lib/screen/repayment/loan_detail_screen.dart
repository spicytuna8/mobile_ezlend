// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/payment-due/payment_due_bloc.dart';
import 'package:loan_project/bloc/repayment/repayment_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/status_loan_helper.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/screen/repayment/repayment_input_screen.dart';
import 'package:loan_project/screen/repayment/widgets/done_repayment.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/ui_your_balance_due.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanDetailScreen extends StatefulWidget {
  final DatumLoan loan;

  const LoanDetailScreen({Key? key, required this.loan}) : super(key: key);

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  final TransactionBloc _transactionBloc = TransactionBloc();
  final RepaymentBloc _repaymentBloc = RepaymentBloc();
  final PaymentDueBloc paymentDueBloc = PaymentDueBloc();

  double? totalmustbepaid;
  bool isOverdue = false;
  String id = '';

  // Check if loan is overdue
  bool get isLoanOverdue {
    return StatusHelper.isApproved(widget.loan.status ?? 0) &&
        (StatusLoanHelper.isOverdue(widget.loan.statusloan ?? 0) ||
            (StatusLoanHelper.isActive(widget.loan.statusloan ?? 0) &&
                StatusHelper.isBlacklisted(widget.loan.blacklist ?? 0)));
  }

  void getId() async {
    id = await preferencesHelper.getStringSharedPref('id');
    paymentDueBloc.add(CheckDueDateEvent(ic: id));

    // Check loan details
    _transactionBloc.add(CheckLoanEvent(packageId: widget.loan.id.toString()));
    _repaymentBloc.add(GetListPaymentEvent(loanpackageid: widget.loan.id.toString()));

    setState(() {
      isOverdue = isLoanOverdue;
    });
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: _transactionBloc,
      listener: (context, state) {
        if (state is CheckLoanSuccess) {
          log('loan detail check loan success ${state.data.toJson().toString()}');
          setState(() {
            if (state.data.data?.totalmustbepaid != null) {
              totalmustbepaid = double.parse(state.data.data?.totalmustbepaid is int
                  ? state.data.data?.totalmustbepaid.toString()
                  : state.data.data?.totalmustbepaid);
            }
          });
        } else if (state is CheckLoanError) {
          log('error check loan ${state.message}');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Loan Detail',
            style: white18w800,
          ),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<TransactionBloc, TransactionState>(
            bloc: _transactionBloc,
            listener: (context, state) {
              // Already handled above
            },
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Loan Balance Card with Payment Due
                    UIYourBalanceDue(
                      balance: isOverdue || totalmustbepaid != null
                          ? totalmustbepaid?.toDouble()
                          : double.tryParse(widget.loan.totalreturn ?? widget.loan.loanamount ?? '0') ?? 0,
                      isLoading: false,
                      statusBadge: isOverdue
                          ? Container(
                              width: 69,
                              height: 22,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFE02424),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  Languages.of(context).overdue,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                Languages.of(context).active,
                                style: white12w400,
                              ),
                            ),
                      customBalanceText:
                          'HKD ${GlobalFunction().formattedMoney(isOverdue || totalmustbepaid != null ? totalmustbepaid?.toDouble() : double.tryParse(widget.loan.totalreturn ?? widget.loan.loanamount ?? '0') ?? 0)}',
                      paymentDueContent: BlocConsumer<PaymentDueBloc, PaymentDueState>(
                        bloc: paymentDueBloc,
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is CheckDueDateLoading) {
                            return const SizedBox(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is CheckDueDateSuccess) {
                            return Text(
                              state.data.data?.duedate != null
                                  ? DateFormat('yyyy-MM-dd').format(state.data.data!.duedate!)
                                  : '--/--/--',
                              style: white12w400,
                            );
                          } else {
                            return Text(
                              '--/--/--',
                              style: white12w400,
                            );
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 32.0),

                    // Overdue Warning
                    if (isOverdue)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF261616),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: Color(0xFFF46C7C)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/icons/ic_info_danger.png',
                              width: 20,
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                Languages.of(context).overdueLoanMessage,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 32.0),

                    // Payment Button
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      decoration:
                          BoxDecoration(color: const Color(0xFF252422), borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            Languages.of(context).payment,
                            style: white16w600,
                          ),
                          subtitle: Text(
                            Languages.of(context).timeForRepayment,
                            style: const TextStyle(
                              color: Color(0xFF7D8998),
                              fontSize: 12,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: MainButtonGradient(
                              title: Languages.of(context).payNow,
                              onTap: () {
                                context.pushNamed(repaymentInput,
                                    extra: RepaymentInputParam(
                                        idLoan: widget.loan.id,
                                        idLoanDetail: widget.loan.loanPackageDetails!.isNotEmpty
                                            ? widget.loan.loanPackageDetails?.last.id
                                            : 0));
                              },
                            ),
                          )),
                    ),

                    const SizedBox(height: 24.0),

                    // Payment History Section
                    Text(
                      Languages.of(context).doneRepayment,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Gabarito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    DoneRepayment(
                      repaymentBloc: _repaymentBloc,
                      loanpackgeid: widget.loan.id ?? 0,
                    ),

                    const SizedBox(height: 100), // Bottom padding
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
