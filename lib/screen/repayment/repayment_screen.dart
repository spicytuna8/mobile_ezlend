// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/payment-due/payment_due_bloc.dart';
import 'package:loan_project/bloc/repayment/repayment_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/screen/repayment/repayment_input_screen.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepaymentScreen extends StatefulWidget {
  const RepaymentScreen({Key? key}) : super(key: key);

  @override
  State<RepaymentScreen> createState() => _RepaymentScreenState();
}

class _RepaymentScreenState extends State<RepaymentScreen> {
  PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  final TransactionBloc _transactionBloc = TransactionBloc();
  final RepaymentBloc _repaymentBloc = RepaymentBloc();
  final PaymentDueBloc paymentDueBloc = PaymentDueBloc();

  DatumLoan? dataLoan;
  ResponseGetLoan? dataHistory;
  List<DatumLoan> listLoan = [];
  bool isHaveData = true;
  double? totalmustbepaid;
  int? idloan;
  bool isOverdue = false;
  bool isBlocked = false;
  String id = '';

  // Calculate total balance from all active loans
  double calculateTotalLoanBalance() {
    double totalBalance = 0.0;

    for (DatumLoan loan in listLoan) {
      // Check if loan is active (status 3 and statusloan 4, 6, 7, or 8)
      if (loan.status == 3 &&
          (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8)) {
        try {
          // Use totalreturn (total amount to be repaid) if available, otherwise use loanamount
          String amountStr = loan.totalreturn ?? loan.loanamount ?? '0';
          if (amountStr.isNotEmpty) {
            double loanAmount = double.parse(amountStr);
            totalBalance += loanAmount;
          }
        } catch (e) {
          log('Error parsing loan amount for loan ${loan.id}: $e');
        }
      }
    }

    return totalBalance;
  }

  // Check if a specific loan is overdue
  bool isLoanOverdue(DatumLoan loan) {
    return loan.status == 3 &&
        (loan.statusloan == 7 ||
            loan.statusloan == 6 ||
            loan.statusloan == 8 ||
            (loan.statusloan == 4 && loan.blacklist == 9));
  }

  // Get status text for a loan
  String getLoanStatusText(DatumLoan loan) {
    if (isLoanOverdue(loan)) {
      return Languages.of(context).overdue;
    } else if (loan.status == 3 && loan.statusloan == 4) {
      return Languages.of(context).active;
    } else if ((loan.status == 0 || loan.status == 1 || loan.status == 10) && loan.statusloan == 4) {
      return Languages.of(context).pending;
    }
    return Languages.of(context).noActive;
  }

  // Build individual loan item widget
  Widget _buildLoanItem(DatumLoan loan) {
    bool isOverdue = isLoanOverdue(loan);
    String loanAmount = loan.totalreturn ?? loan.loanamount ?? '0';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF252422),
        borderRadius: BorderRadius.circular(12),
        border: isOverdue ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
      ),
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
                    Text(
                      loan.packageName ?? 'Loan Package',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'HKD ${GlobalFunction().formattedMoney(double.tryParse(loanAmount) ?? 0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gabarito',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOverdue ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      getLoanStatusText(loan),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    height: 32,
                    child: MainButtonGradient(
                      title: Languages.of(context).payNow,
                      onTap: () {
                        // Navigate to loan detail/repayment input
                        context.pushNamed(repaymentInput,
                            extra: RepaymentInputParam(
                                idLoan: loan.id,
                                idLoanDetail:
                                    loan.loanPackageDetails!.isNotEmpty ? loan.loanPackageDetails?.last.id : 0));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.6),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'Loan Date: ${loan.dateloan != null ? DateFormat('dd MMM yyyy').format(loan.dateloan!) : 'N/A'}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getId() async {
    id = await preferencesHelper.getStringSharedPref('id');
    paymentDueBloc.add(CheckDueDateEvent(ic: id));

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getId();
    _transactionBloc.add(const GetLoanEvent());
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: _transactionBloc,
      listener: (context, state) {
        if (state is GetLoanSuccess) {
          setState(() {
            listLoan = state.data.data ?? [];
          });

          if (state.data.data!.isNotEmpty) {
            state.data.data?.forEach((element) {
              if (element.status == 3 && element.statusloan == 4) {
                setState(() {
                  idloan = element.id;
                });
                log('test 3-4 id loan $idloan');

                _repaymentBloc.add(GetListPaymentEvent(loanpackageid: idloan.toString()));
                setState(() {
                  dataLoan = element;
                  isOverdue = false;

                  // if (dataLoan != null) {
                  _transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                  // }
                  isHaveData = false;
                });
              } else if (element.status == 3 && element.statusloan == 7 ||
                  element.status == 3 && element.statusloan == 6 ||
                  element.status == 3 && element.statusloan == 8 ||
                  element.status == 3 && element.statusloan == 4 && element.blacklist == 9) {
                log('test 3-7');
                _repaymentBloc.add(GetListPaymentEvent(loanpackageid: element.id.toString()));
                setState(() {
                  dataLoan = element;
                  isOverdue = true;
                  // if (dataLoan != null) {
                  _transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                  // }
                  isHaveData = false;
                });
              }
              // else if (element.status == 3 && element.statusloan == 8) {
              //   log('test 3-8');
              //   _repaymentBloc.add(
              //       GetListPaymentEvent(loanpackageid: element.id.toString()));
              //   setState(() {
              //     dataLoan = element;
              //     isOverdue = false;
              //     isBlocked = true;
              //     // if (dataLoan != null) {
              //     _transactionBloc
              //         .add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
              //     // }
              //     isHaveData = false;
              //   });
              // }
              else if (element.status == 0 && element.statusloan == 4 ||
                  element.status == 1 && element.statusloan == 4 ||
                  element.status == 10 && element.statusloan == 4) {
                setState(() {
                  dataLoan = element;
                  isHaveData = false;
                  // isPending = false;
                  isOverdue = false;
                  // _transactionBloc
                  //     .add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                });
              } else {
                log('test');
                setState(() {
                  dataLoan = null;
                  isOverdue = false;

                  isHaveData = false;
                });
              }
            });
          } else if (state.data.data!.isEmpty) {
            log('masuk sana');

            setState(() {
              dataLoan = null;
              isOverdue = false;

              isHaveData = false;
            });
          }
        } else if (state is GetLoanError) {
          log('${state.message} err');
          setState(() {
            isHaveData = false;
          });
        }
        // TODO: implement listener
      },
      child: RefreshIndicator(
        onRefresh: () async {
          getId();
          _transactionBloc.add(const GetLoanEvent());
        },
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Scaffold(
          backgroundColor: const Color(0xff000000),
          appBar: AppBar(
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  Languages.of(context).repayment,
                  style: white18w800,
                ),
              ),
            ),
            // title: Text(Languages.of(context).repayment),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: isHaveData
                ? const Center(
                    child: RefreshProgressIndicator(),
                  )
                : BlocConsumer<TransactionBloc, TransactionState>(
                    bloc: _transactionBloc,
                    listener: (context, state) {
                      if (state is CheckLoanSuccess) {
                        log('ini check loan sukses ${state.data.toJson().toString()}');
                        setState(() {
                          if (state.data.data?.totalmustbepaid != null) {
                            totalmustbepaid = double.parse(state.data.data?.totalmustbepaid is int
                                ? state.data.data?.totalmustbepaid.toString()
                                : state.data.data?.totalmustbepaid);
                          }
                        });
                      } else if (state is CheckLoanError) {
                        log('errror cek loan${state.message}');
                      }
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20.0),

                              // Total Loan Balance Card
                              Container(
                                padding: const EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                    image: const DecorationImage(
                                        image: AssetImage('assets/images/promo2.png'), fit: BoxFit.cover)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Languages.of(context).loanBalance,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'HKD ${GlobalFunction().formattedMoney(calculateTotalLoanBalance())}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontFamily: 'Gabarito',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      listLoan.isEmpty
                                          ? Languages.of(context).dontHaveActiveLoan
                                          : '${listLoan.where((loan) => loan.status == 3 && (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8)).length} ${Languages.of(context).active} ${Languages.of(context).loan}s',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Loan List Section
                              if (listLoan.isNotEmpty) ...[
                                const Text(
                                  "Your Loans", // Using literal text since yourLoans doesn't exist
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Gabarito',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Loan Items List
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: listLoan
                                      .where((loan) =>
                                          loan.status == 3 &&
                                          (loan.statusloan == 4 ||
                                              loan.statusloan == 6 ||
                                              loan.statusloan == 7 ||
                                              loan.statusloan == 8))
                                      .length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final activeLoan = listLoan
                                        .where((loan) =>
                                            loan.status == 3 &&
                                            (loan.statusloan == 4 ||
                                                loan.statusloan == 6 ||
                                                loan.statusloan == 7 ||
                                                loan.statusloan == 8))
                                        .toList()[index];

                                    return _buildLoanItem(activeLoan);
                                  },
                                ),
                              ] else ...[
                                // No loans state
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF252422),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.receipt_long_outlined,
                                        color: Colors.white.withOpacity(0.5),
                                        size: 48,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        Languages.of(context).dontHaveActiveLoan,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 100), // Bottom padding
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
