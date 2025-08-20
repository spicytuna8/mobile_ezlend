// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/member/member_bloc.dart';
import 'package:loan_project/bloc/package/package_bloc.dart';
import 'package:loan_project/bloc/payment-due/payment_due_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/model/response_package_rate.dart';
import 'package:loan_project/screen/loan/history_loan.dart';
import 'package:loan_project/widget/card_blacklist.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoanScreen extends StatefulWidget {
  const MyLoanScreen({Key? key}) : super(key: key);

  @override
  State<MyLoanScreen> createState() => _MyLoanScreenState();
}

class _MyLoanScreenState extends State<MyLoanScreen> {
  PreferencesHelper preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  final PackageBloc _packageBloc = PackageBloc();
  final MemberBloc _memberBloc = MemberBloc();
  final TransactionBloc transactionBloc = TransactionBloc();
  final PaymentDueBloc paymentDueBloc = PaymentDueBloc();
  DatumLoan? dataLoan;
  bool isHaveData = true;
  bool isPending = false;
  int selectedNominal = 0;
  int selectedInterest = 0;
  int? totalmustbepaid;
  List<ItemPackageIndex> listPackage = [];
  List<DatumLoan> listLoan = [];

  ItemPackageIndex? selectedPackage;
  ItemPackageRate? selectedRate;
  int indexSelected = -1;
  bool statusLoanActive = false;
  bool statusLoanPending = false;
  bool isKycApproved = true;
  bool isOverdue = false;
  bool isBlocked = false;
  int loanStatus = 0;
  int status = 0;
  String id = '';
  int _visibleItemCount = 4;
  String phoneService = '';
  String url = "https://wa.me/?text=Hello";

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
  } // Check if any loan is overdue

  bool hasOverdueLoan() {
    return listLoan.any((loan) =>
        loan.status == 3 &&
        (loan.statusloan == 7 ||
            loan.statusloan == 6 ||
            loan.statusloan == 8 ||
            (loan.statusloan == 4 && loan.blacklist == 9)));
  }

  // Get the status text for multiple loans
  String getMultiLoanStatus() {
    if (listLoan.isEmpty) return Languages.of(context).noActive;

    bool hasActive = listLoan.any((loan) => loan.status == 3 && loan.statusloan == 4);
    bool hasPending =
        listLoan.any((loan) => (loan.status == 0 || loan.status == 1 || loan.status == 10) && loan.statusloan == 4);
    bool hasOverdue = hasOverdueLoan();

    if (hasOverdue) return Languages.of(context).overdue;
    if (hasActive) return Languages.of(context).active;
    if (hasPending) return Languages.of(context).pending;

    return Languages.of(context).noActive;
  }

  void getId() async {
    id = await preferencesHelper.getStringSharedPref('id');
    paymentDueBloc.add(CheckDueDateEvent(ic: id));
    phoneService = await preferencesHelper.getStringSharedPref('phone_service');
    url = "https://wa.me/$phoneService?text=";

    setState(() {});
  }

  @override
  void initState() {
    getId();
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
    _memberBloc.add(GetMemberEvent());
    transactionBloc.add(const GetLoanEvent());

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MemberBloc, MemberState>(
          bloc: _memberBloc,
          listener: (context, state) {
            if (state is GetMemberSuccess) {
              // log('sukses get member ${state.data.data?.toJson().toString()}');
              final int kyc1Status = state.data.data?.kyc?['1']['status'] ?? -1;
              final int kyc2Status = state.data.data?.kyc?['2']['status'] ?? -1;
              final int kyc3Status = state.data.data?.kyc?['3']['status'] ?? -1;
              log("${state.data.data?.kyc?['1']?['status']} kyc status");
              if (kyc1Status == -1 || kyc2Status == -1 || kyc3Status == -1) {
                preferencesHelper.setStringSharedPref('kyc_status1', '');
                preferencesHelper.setStringSharedPref('kyc_status2', '');
                preferencesHelper.setStringSharedPref('kyc_status3', '');
              } else {
                preferencesHelper.setStringSharedPref(
                    'kyc_status1', state.data.data?.kyc?['1']['status'].toString() ?? '');
                preferencesHelper.setStringSharedPref(
                    'kyc_status2', state.data.data?.kyc?['2']['status'].toString() ?? '');
                preferencesHelper.setStringSharedPref(
                    'kyc_status3', state.data.data?.kyc?['3']['status'].toString() ?? '');
              }
            } else if (state is GetMemberError) {
              log('statuss error ${state.message}');
            }
            // TODO: implement listener
          },
        ),
        BlocListener<TransactionBloc, TransactionState>(
          bloc: transactionBloc,
          listener: (context, state) {
            if (state is GetLoanError) {
              EasyLoading.dismiss();
            } else if (state is GetLoanSuccess) {
              setState(() {
                listLoan = state.data.data ?? [];
              });
              if (state.data.data!.isNotEmpty) {
                state.data.data?.forEach((element) {
                  if (element.status == 3 && element.statusloan == 4) {
                    setState(() {
                      dataLoan = element;
                      isPending = false;
                      isOverdue = false;

                      transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));

                      isHaveData = false;
                    });
                  } else if (element.status == 3 && element.statusloan == 7 ||
                      element.status == 3 && element.statusloan == 6 ||
                      element.status == 3 && element.statusloan == 8 ||
                      element.status == 3 && element.statusloan == 4 && element.blacklist == 9) {
                    setState(() {
                      dataLoan = element;
                      isPending = false;
                      isOverdue = true;
                      transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));

                      isHaveData = false;
                    });
                  }
                  // else if (element.status == 3 && element.statusloan == 8) {
                  //   setState(() {
                  //     dataLoan = element;
                  //     isPending = false;
                  //     isOverdue = false;
                  //     isBlocked = true;
                  //     transactionBloc.add(
                  //         CheckLoanEvent(packageId: dataLoan!.id.toString()));

                  //     isHaveData = false;
                  //   });
                  // }
                  else if (element.status == 0 && element.statusloan == 4 ||
                      element.status == 1 && element.statusloan == 4 ||
                      element.status == 10 && element.statusloan == 4) {
                    setState(() {
                      dataLoan = element;
                      // isHaveData = false;

                      isPending = false; // true; XXX: Multi-loan
                      isOverdue = false;
                      transactionBloc.add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                    });
                  } else {
                    setState(() {
                      dataLoan = null;
                      isOverdue = false;
                      isPending = false;

                      isHaveData = false;
                    });
                  }
                });
              } else if (state.data.data!.isEmpty) {
                setState(() {
                  dataLoan = null;
                  isOverdue = false;

                  isHaveData = false;
                });
              }
            } else if (state is GetLoanError) {
              setState(() {
                isHaveData = false;
                isOverdue = false;
              });
            }
            EasyLoading.dismiss();

            // TODO: implement listener
          },
        )
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          EasyLoading.show(maskType: EasyLoadingMaskType.black);
          getId();
          _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
          _memberBloc.add(GetMemberEvent());
          transactionBloc.add(const GetLoanEvent());
        },
        // triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: const Color(0xff000000),
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    Languages.of(context).myLoan,
                    style: white18w800,
                  ),
                ),
              ),
            ),
            body: isBlocked
                ? const CardBlacklist()
                : isPending
                    ? SingleChildScrollView(
                        child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/ic_timer.png',
                              width: 131.5,
                              height: 150,
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            SizedBox(
                              width: 330,
                              child: Text(
                                Languages.of(context).loanRequestUnderReview,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF7D8998),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60.0,
                            ),
                            SizedBox(
                              width: 330,
                              child: Text(
                                Languages.of(context).contactForInformation,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF7D8998),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            GlobalFunction().customerServiceButton(url, context)
                          ],
                        ),
                      ))
                    : SizedBox(
                        // margin: const EdgeInsets.all(16),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocConsumer<TransactionBloc, TransactionState>(
                                      listener: (context, state) {
                                        if (state is CheckLoanSuccess) {
                                          setState(() {
                                            totalmustbepaid = state.data.data?.totalmustbepaid;
                                          });
                                        }
                                      },
                                      bloc: transactionBloc,
                                      builder: (context, state) {
                                        if (state is CheckLoanSuccess) {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width,
                                                // height: 145,
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                    image: const DecorationImage(
                                                        image: AssetImage('assets/images/promo2.png'),
                                                        fit: BoxFit.cover)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Languages.of(context).loanBalance,
                                                          style: white12w400,
                                                        ),
                                                        hasOverdueLoan()
                                                            ? Container(
                                                                width: 69,
                                                                height: 22,
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10, vertical: 2),
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
                                                                    style: GoogleFonts.inter(
                                                                      color: Colors.white,
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
                                                                height: 22,
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10, vertical: 2),
                                                                decoration: ShapeDecoration(
                                                                  shape: RoundedRectangleBorder(
                                                                    side:
                                                                        const BorderSide(width: 1, color: Colors.white),
                                                                    borderRadius: BorderRadius.circular(20),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  getMultiLoanStatus(),
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.inter(
                                                                    color: Colors.white,
                                                                    fontSize: 12,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8.0,
                                                    ),
                                                    Text(
                                                      'HKD ${GlobalFunction().formattedMoney(calculateTotalLoanBalance())}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 36,
                                                        fontFamily: 'Gabarito',
                                                        fontWeight: FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25.0,
                                                    ),
                                                    Text(
                                                      listLoan.isEmpty
                                                          ? Languages.of(context).dontHaveActiveLoan
                                                          : listLoan.length == 1
                                                              ? (listLoan.first.packageName ?? '')
                                                              : '${listLoan.where((loan) => loan.status == 3 && (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8)).length} ${Languages.of(context).active} ${Languages.of(context).loan}s',
                                                      style: white12w400,
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF252422),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(12),
                                                      bottomRight: Radius.circular(12)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      //// TODO: minta payment due
                                                      '${Languages.of(context).paymentDue} ',
                                                      style: white12w400,
                                                    ),
                                                    BlocConsumer<PaymentDueBloc, PaymentDueState>(
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
                                                            //// TODO: minta payment due
                                                            dataLoan == null
                                                                ? '--/--/--'
                                                                : DateFormat('yyyy-MM-dd')
                                                                    .format(state.data.data!.duedate!),
                                                            style: white12w400,
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width,
                                                // height: 145,
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                    image: const DecorationImage(
                                                        image: AssetImage('assets/images/promo2.png'),
                                                        fit: BoxFit.cover)),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Languages.of(context).loanBalance,
                                                          style: white12w400,
                                                        ),
                                                        Container(
                                                          height: 22,
                                                          padding:
                                                              const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                          decoration: ShapeDecoration(
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(width: 1, color: Colors.white),
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            getMultiLoanStatus(),
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.inter(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8.0,
                                                    ),
                                                    Text(
                                                      'HKD ${listLoan.isEmpty ? '0' : GlobalFunction().formattedMoney(calculateTotalLoanBalance())}',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 36,
                                                        fontFamily: 'Gabarito',
                                                        fontWeight: FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 25.0,
                                                    ),
                                                    Text(
                                                      listLoan.isEmpty
                                                          ? Languages.of(context).dontHaveActiveLoan
                                                          : listLoan.length == 1
                                                              ? (listLoan.first.packageName ?? '')
                                                              : '${listLoan.where((loan) => loan.status == 3 && (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8)).length} ${Languages.of(context).active} ${Languages.of(context).loan}s',
                                                      style: white12w400,
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.all(16),
                                                width: MediaQuery.of(context).size.width,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF252422),
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft: Radius.circular(12),
                                                      bottomRight: Radius.circular(12)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      //// TODO: minta payment due
                                                      Languages.of(context).paymentDue,
                                                      style: white12w400,
                                                    ),
                                                    BlocConsumer<PaymentDueBloc, PaymentDueState>(
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
                                                            //// TODO: minta payment due
                                                            dataLoan == null
                                                                ? '--/--/--'
                                                                : DateFormat('yyyy-MM-dd')
                                                                    .format(state.data.data!.duedate!),
                                                            style: white12w400,
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 16.0,
                                    ),
                                    dataLoan == null
                                        ? Container()
                                        : isOverdue
                                            ? Container(
                                                width: 350,
                                                height: 58,
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
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    SizedBox(
                                                      width: 290,
                                                      child: Text(
                                                        Languages.of(context).overdueLoanMessage,
                                                        style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                    /* XXX: Multi-loan
                                    
                                    Container(
                                                width: 350,
                                                height: 60,
                                                padding: const EdgeInsets.all(12),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: const Color(0xFF1F2A37),
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(width: 1, color: Color(0xFFA4CAFE)),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/ic_info.png',
                                                      width: 20,
                                                    ),
                                                    const SizedBox(
                                                      width: 8.0,
                                                    ),
                                                    SizedBox(
                                                      width: 290,
                                                      child: Text(
                                                        Languages.of(context).clearLoanBeforeApplying,
                                                        style: GoogleFonts.roboto(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ), */
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Languages.of(context).ourPackages,
                                          style: white16w600,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              // Menampilkan semua item saat tombol "See More" diklik
                                              _visibleItemCount = listPackage.length;
                                            });
                                          },
                                          child: Text(
                                            Languages.of(context).seeMore,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              color: const Color(0xFF7D8998),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    BlocConsumer<PackageBloc, PackageState>(
                                      bloc: _packageBloc,
                                      listener: (context, state) {
                                        if (state is GetIndexPackageError) {
                                          EasyLoading.dismiss();
                                        } else if (state is GetIndexPackageSuccess) {
                                          EasyLoading.dismiss();
                                          setState(() {
                                            listPackage = state.data.data.items;
                                            if (listPackage.isNotEmpty) {
                                              selectedPackage = listPackage[0];
                                            }
                                          });
                                        }
                                        // TODO: implement listener
                                      },
                                      builder: (context, state) {
                                        if (state is GetIndexPackageSuccess) {
                                          return Column(
                                            children: [
                                              GridView.builder(
                                                padding: EdgeInsets.zero,
                                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 1.5,
                                                  crossAxisCount: 2,
                                                  mainAxisSpacing: 16,
                                                  crossAxisSpacing: 16,
                                                ),
                                                itemCount: state.data.data.items.length > 4
                                                    ? _visibleItemCount
                                                    : state.data.data.items.length,
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (BuildContext context, int index) {
                                                  ItemPackageIndex data = state.data.data.items[index];
                                                  return GestureDetector(
                                                    /* XXX: Multi-loan
                                                    onTap: dataLoan != null
                                                        ? null
                                                        : () {
                                                            setState(() {
                                                              indexSelected = index;
                                                              selectedPackage = data;
                                                              selectedNominal = index;
                                                            });
                                                          }, */

                                                    onTap: () {
                                                      setState(() {
                                                        indexSelected = index;
                                                        selectedPackage = data;
                                                        selectedNominal = index;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                            width: 1,
                                                            color: indexSelected == index
                                                                ? const Color(0xFFFED607)
                                                                : const Color(0xFF252422).withOpacity(0.4)),
                                                        color: indexSelected == index
                                                            ? Colors.amber.withOpacity(0.4)
                                                            : const Color(0xFF252422).withOpacity(0.9),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            data.name,
                                                            style: GoogleFonts.inter(
                                                              color: indexSelected == index
                                                                  ? const Color(0xFFD1D5DB)
                                                                  : const Color(0xFFD1D5DB).withOpacity(0.4),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            GlobalFunction()
                                                                .formattedMoney(double.parse(data.amount))
                                                                .toString(),
                                                            style: GoogleFonts.inter(
                                                              color: indexSelected == index
                                                                  ? Colors.white
                                                                  : const Color(0xFFD1D5DB).withOpacity(0.4),
                                                              fontSize: 24,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 25.0,
                                                          ),
                                                          // Text(
                                                          //   '${Languages.of(context).returnDay} ${data.returnDay}',
                                                          //   style: GoogleFonts
                                                          //       .inter(
                                                          //     color: indexSelected ==
                                                          //             index
                                                          //         ? const Color(
                                                          //             0xFF7D8998)
                                                          //         : const Color(
                                                          //                 0xFFD1D5DB)
                                                          //             .withOpacity(
                                                          //                 0.4),
                                                          //     fontSize: 12,
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .w600,
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                height: 16.0,
                                              ),
                                              BlocConsumer<TransactionBloc, TransactionState>(
                                                bloc: transactionBloc,
                                                listener: (context, state) {
                                                  if (state is PostLoanSuccess) {
                                                    GlobalFunction().allDialog(context,
                                                        title: Languages.of(context).successSubmitLoanRequest,
                                                        onTap: () {
                                                      context.pushNamed(bottomNavigation, extra: 0);
                                                    });
                                                  } else if (state is PostLoanError) {
                                                    GlobalFunction().allDialog(
                                                      context,
                                                      title: state.message,
                                                    );
                                                  }
                                                  // TODO: implement listener
                                                },
                                                builder: (context, state) {
                                                  return MainButtonGradient(
                                                    title: state is PostLoanLoading
                                                        ? '${Languages.of(context).loading}...'
                                                        : Languages.of(context).continueText,
                                                    onTap: indexSelected == -1 || state is PostLoanLoading
                                                        ? null
                                                        : () async {
                                                            // Multi-loan: Check if user has loan history (already did KYC)
                                                            if (listLoan.isNotEmpty) {
                                                              // User has loan history, directly submit loan
                                                              log('User has loan history, skip KYC - direct submit loan');
                                                              transactionBloc.add(PostLoanEvent(
                                                                packageId: selectedPackage!.id.toString(),
                                                                dateLoan:
                                                                    DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                              ));
                                                            } else {
                                                              // First time user, check KYC status
                                                              String statusKyc1 = await preferencesHelper
                                                                  .getStringSharedPref('kyc_status1');
                                                              String statusKyc2 = await preferencesHelper
                                                                  .getStringSharedPref('kyc_status2');
                                                              String statusKyc3 = await preferencesHelper
                                                                  .getStringSharedPref('kyc_status3');
                                                              log("First time user - status kyc $statusKyc1");

                                                              if (statusKyc1 == '0' ||
                                                                  statusKyc2 == '0' ||
                                                                  statusKyc3 == '0') {
                                                                GlobalFunction().allDialog(context,
                                                                    title:
                                                                        Languages.of(context).kycLoanPendingApproval);
                                                              } else if (statusKyc1 == '2' ||
                                                                  statusKyc2 == '2' ||
                                                                  statusKyc3 == '2') {
                                                                GlobalFunction().allDialog(context,
                                                                    title: Languages.of(context).kycRejected,
                                                                    onTap: () {
                                                                  context.pushNamed(kyc1Input, extra: selectedPackage);
                                                                });
                                                              } else if (statusKyc1 == '1' &&
                                                                  statusKyc2 == '1' &&
                                                                  statusKyc3 == '1') {
                                                                log('First time user KYC approved - submit loan');
                                                                transactionBloc.add(PostLoanEvent(
                                                                  packageId: selectedPackage!.id.toString(),
                                                                  dateLoan:
                                                                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                                                ));
                                                              } else {
                                                                context.pushNamed(kyc1Input, extra: selectedPackage);
                                                              }
                                                            }
                                                          },
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        } else if (state is GetIndexPackageError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: MainButton(
                                              title: Languages.of(context).tryAgain,
                                              onTap: () {
                                                _packageBloc.add(const GetIndexPackageEvent(page: 1, perPage: 10));
                                              },
                                            ),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 24.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Languages.of(context).historyLoan,
                                          style: white16w600,
                                        ),
                                        Text(
                                          Languages.of(context).seeMore,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.inter(
                                            color: const Color(0xFF7D8998),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8.0,
                                    ),
                                    HistoryLoan(
                                      data: listLoan,
                                    ),
                                    // const HistoryLoan(),
                                    const SizedBox(
                                      height: 50.0,
                                    ),
                                  ],
                                ),
                              ),

                              // SlidingUpPanel(
                              //   borderRadius: const BorderRadius.only(
                              //       topLeft: Radius.circular(20.0),
                              //       topRight: Radius.circular(20.0)),
                              //   color: Colors.transparent,
                              //   boxShadow: const [],
                              //   panel: _scrollingList(),
                              //   minHeight: 100,
                              //   maxHeight: 1000,
                              //   onPanelSlide: (position) {
                              //     setState(() {
                              //       _isPanelOpen = position > 0.5;
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
