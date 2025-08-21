// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_project/bloc/payment-due/payment_due_bloc.dart';
import 'package:loan_project/bloc/repayment/repayment_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/status_loan_helper.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_check_loan.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/widget/ui_repayment_loan_item.dart';
import 'package:loan_project/widget/ui_your_balance.dart';
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
  double? totalmustbepaid;
  int? idloan;
  bool isOverdue = false;
  bool isBlocked = false;
  String id = '';

  // Store CheckLoan data for each loan
  Map<String, ResponseCheckLoan> checkLoanDataMap = {};
  List<String> pendingCheckLoanIds = []; // Track loans waiting for CheckLoan API
  int completedCheckLoanCount = 0; // Track completed CheckLoan calls

  // Check if all active loans have CheckLoan data
  bool areAllCheckLoanDataLoaded() {
    if (listLoan.isEmpty) return true;

    List<String> activeLoanIds = [];
    for (DatumLoan loan in listLoan) {
      // Use helper classes for cleaner status checking
      if (StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.requiresPayment(loan.statusloan ?? 0)) {
        activeLoanIds.add(loan.id.toString());
      }
    }

    // Check if we have CheckLoan data for all active loans
    for (String loanId in activeLoanIds) {
      if (!checkLoanDataMap.containsKey(loanId)) {
        return false;
      }
    }

    return true;
  }

  // Calculate total balance from CheckLoan API data (loanamount - alreadypaid)
  double calculateTotalLoanBalance() {
    double totalBalance = 0.0;

    log('REPAYMENT SCREEN - Starting balance calculation');
    log('REPAYMENT SCREEN - Total loans in listLoan: ${listLoan.length}');
    log('REPAYMENT SCREEN - CheckLoan data map size: ${checkLoanDataMap.length}');

    for (DatumLoan loan in listLoan) {
      // Include all loans with approved status and requires payment
      if (StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.requiresPayment(loan.statusloan ?? 0)) {
        String loanId = loan.id.toString();

        log('REPAYMENT SCREEN - Processing loan ${loan.id}: status=${loan.status}, statusloan=${loan.statusloan}');

        // Check if we have CheckLoan data for this loan
        if (checkLoanDataMap.containsKey(loanId)) {
          try {
            ResponseCheckLoan checkLoanData = checkLoanDataMap[loanId]!;

            // Calculate remaining balance: loanamount - alreadypaid
            double loanAmount = double.parse(checkLoanData.loanamount ?? '0');
            double alreadyPaid = double.parse(checkLoanData.alreadypaid ?? '0');
            double remainingBalance = loanAmount - alreadyPaid;

            // Add remaining balance (can be positive or negative)
            totalBalance += remainingBalance;
            log('REPAYMENT SCREEN - Loan ${loan.id}: loanamount=$loanAmount, alreadypaid=$alreadyPaid, remaining=$remainingBalance, running total: $totalBalance');
          } catch (e) {
            log('REPAYMENT SCREEN - Error calculating balance for loan ${loan.id}: $e');
            // Fallback to loanamount if CheckLoan data parsing fails
            try {
              String amountStr = loan.loanamount ?? '0';
              if (amountStr.isNotEmpty) {
                double loanAmount = double.parse(amountStr);
                totalBalance += loanAmount;
                log('REPAYMENT SCREEN - Fallback - Added loan ${loan.id}: $loanAmount, running total: $totalBalance');
              }
            } catch (e2) {
              log('REPAYMENT SCREEN - Error parsing fallback loan amount for loan ${loan.id}: $e2');
            }
          }
        } else {
          // Fallback to loanamount while waiting for CheckLoan data
          try {
            String amountStr = loan.loanamount ?? '0';
            if (amountStr.isNotEmpty) {
              double loanAmount = double.parse(amountStr);
              totalBalance += loanAmount;
              log('REPAYMENT SCREEN - Waiting for CheckLoan - Added loan ${loan.id}: $loanAmount, running total: $totalBalance');
            }
          } catch (e) {
            log('REPAYMENT SCREEN - Error parsing loan amount for loan ${loan.id}: $e');
          }
        }
      }
    }

    log('REPAYMENT SCREEN - Final total balance: $totalBalance');
    return totalBalance;
  }

  // Get the accurate total balance - only use CheckLoan data when all data is ready
  double getDisplayBalance() {
    if (listLoan.isEmpty) {
      return 0.0;
    }

    // Only use calculateTotalLoanBalance if all CheckLoan data is loaded
    if (areAllCheckLoanDataLoaded()) {
      log('Using accurate balance from CheckLoan data: ${calculateTotalLoanBalance()}');
      return calculateTotalLoanBalance();
    } else {
      // Show 0 while CheckLoan data is being fetched to avoid showing wrong balance
      log('CheckLoan data not ready yet. Showing 0 to avoid wrong balance.');
      return 0.0;
    }
  }

  // Trigger CheckLoan API for all active loans one by one
  void loadCheckLoanDataForAllLoans() {
    pendingCheckLoanIds.clear();
    completedCheckLoanCount = 0;

    // Collect all active loan IDs that need CheckLoan data
    for (DatumLoan loan in listLoan) {
      if (StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.requiresPayment(loan.statusloan ?? 0)) {
        String loanId = loan.id.toString();
        if (!checkLoanDataMap.containsKey(loanId)) {
          pendingCheckLoanIds.add(loanId);
        }
      }
    }

    log('Found ${pendingCheckLoanIds.length} loans that need CheckLoan data');

    // Start loading CheckLoan data for the first loan
    if (pendingCheckLoanIds.isNotEmpty) {
      loadNextCheckLoanData();
    }
  }

  // Load CheckLoan data for the next loan in queue
  void loadNextCheckLoanData() {
    if (completedCheckLoanCount < pendingCheckLoanIds.length) {
      String loanId = pendingCheckLoanIds[completedCheckLoanCount];
      log('Loading CheckLoan data for loan $loanId (${completedCheckLoanCount + 1}/${pendingCheckLoanIds.length})');
      _transactionBloc.add(CheckLoanEvent(packageId: loanId));
    }
  }

  // Check if a specific loan is overdue
  bool isLoanOverdue(DatumLoan loan) {
    return StatusHelper.isApproved(loan.status ?? 0) &&
        (StatusLoanHelper.isOverdue(loan.statusloan ?? 0) ||
            (StatusLoanHelper.isActive(loan.statusloan ?? 0) && StatusHelper.isBlacklisted(loan.blacklist ?? 0)));
  }

  // Get status text for a loan
  String getLoanStatusText(DatumLoan loan) {
    if (isLoanOverdue(loan)) {
      return Languages.of(context).overdue;
    } else if (StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.isActive(loan.statusloan ?? 0)) {
      return Languages.of(context).active;
    } else if (StatusHelper.isPending(loan.status ?? 0) && StatusLoanHelper.isActive(loan.statusloan ?? 0)) {
      return Languages.of(context).pending;
    }
    return Languages.of(context).noActive;
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

            // Load CheckLoan data for all active loans to get accurate balance
            loadCheckLoanDataForAllLoans();

            if (state.data.data!.isNotEmpty) {
              state.data.data?.forEach((element) {
                if (StatusHelper.isApproved(element.status ?? 0) &&
                    StatusLoanHelper.isActive(element.statusloan ?? 0)) {
                  setState(() {
                    idloan = element.id;
                  });
                  log('test approved-active id loan $idloan');

                  _repaymentBloc.add(GetListPaymentEvent(loanpackageid: idloan.toString()));
                  setState(() {
                    dataLoan = element;
                    isOverdue = false;
                  });
                } else if (isLoanOverdue(element)) {
                  log('test overdue loan');
                  _repaymentBloc.add(GetListPaymentEvent(loanpackageid: element.id.toString()));
                  setState(() {
                    dataLoan = element;
                    isOverdue = true;
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
                else if (StatusHelper.isPending(element.status ?? 0) &&
                    StatusLoanHelper.isActive(element.statusloan ?? 0)) {
                  setState(() {
                    dataLoan = element;
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
                  });
                }
              });
            } else if (state.data.data!.isEmpty) {
              log('masuk sana');

              setState(() {
                dataLoan = null;
                isOverdue = false;
              });
            }
          } else if (state is GetLoanError) {
            log('${state.message} err');
          } else if (state is CheckLoanSuccess) {
            setState(() {
              // Store CheckLoan data for the current loan being processed
              if (completedCheckLoanCount < pendingCheckLoanIds.length) {
                String loanId = pendingCheckLoanIds[completedCheckLoanCount];
                checkLoanDataMap[loanId] = state.data;
                log('Stored CheckLoan data for loan $loanId: loanamount=${state.data.loanamount}, alreadypaid=${state.data.alreadypaid}');

                completedCheckLoanCount++;

                // Load next loan's CheckLoan data
                loadNextCheckLoanData();

                // Trigger UI refresh when all CheckLoan data is loaded
                if (completedCheckLoanCount >= pendingCheckLoanIds.length) {
                  log('All CheckLoan data loaded. Final balance: ${calculateTotalLoanBalance()}');
                  // setState will automatically trigger UI refresh
                }
              }

              // Update totalmustbepaid for current displayed loan
              if (state.data.data?.totalmustbepaid != null) {
                totalmustbepaid = state.data.data?.totalmustbepaid is int
                    ? state.data.data?.totalmustbepaid.toDouble()
                    : double.parse(state.data.data?.totalmustbepaid);
              }
            });
          } else if (state is CheckLoanError) {
            // Handle error and continue with next loan
            setState(() {
              if (completedCheckLoanCount < pendingCheckLoanIds.length) {
                String loanId = pendingCheckLoanIds[completedCheckLoanCount];
                log('Error loading CheckLoan data for loan $loanId: ${state.message}');

                completedCheckLoanCount++;

                // Continue with next loan even if current one failed
                loadNextCheckLoanData();
              }
            });
          }
          // TODO: implement listener
        },
        child: RefreshIndicator(
          onRefresh: () async {
            // Clear CheckLoan data cache on refresh
            checkLoanDataMap.clear();
            pendingCheckLoanIds.clear();
            completedCheckLoanCount = 0;

            getId();
            _transactionBloc.add(const GetLoanEvent());
          },
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          child: Scaffold(
            backgroundColor: const Color(0xff000000),
            appBar: AppBar(
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(20.0),
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
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Loan Balance Card
                    UIYourBalance(
                      balance: areAllCheckLoanDataLoaded() && listLoan.isNotEmpty ? getDisplayBalance() : null,
                      isLoading: !areAllCheckLoanDataLoaded() && listLoan.isNotEmpty,
                      subTitle: listLoan.isEmpty
                          ? Languages.of(context).dontHaveActiveLoan
                          : '${listLoan.where((loan) => StatusHelper.isApproved(loan.status ?? 0) && StatusLoanHelper.requiresPayment(loan.statusloan ?? 0)).length} ${Languages.of(context).active} ${Languages.of(context).loan}s',
                    ),

                    const SizedBox(height: 24),

                    // Loan List Section
                    if (listLoan.isNotEmpty) ...[
                      Text(
                        Languages.of(context).yourLoans,
                        style: const TextStyle(
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
                                StatusHelper.isApproved(loan.status ?? 0) &&
                                StatusLoanHelper.requiresPayment(loan.statusloan ?? 0))
                            .length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final activeLoan = listLoan
                              .where((loan) =>
                                  StatusHelper.isApproved(loan.status ?? 0) &&
                                  StatusLoanHelper.requiresPayment(loan.statusloan ?? 0))
                              .toList()[index];

                          return UIRepaymentLoanItem(loan: activeLoan);
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
            ),
          ), // RefreshIndicator closing
        )); // BlocListener closing
  } // build method closing
} // class closing