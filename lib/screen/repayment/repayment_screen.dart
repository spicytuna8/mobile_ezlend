// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:loan_project/screen/repayment/widgets/done_repayment.dart';
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
  bool isHaveData = true;
  double? totalmustbepaid;
  int? idloan;
  bool isOverdue = false;
  bool isBlocked = false;
  String id = '';
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
                      if (state is CheckLoanSuccess) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 145,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                      image: const DecorationImage(
                                          image: AssetImage('assets/images/promo2.png'), fit: BoxFit.cover)),
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
                                          isOverdue
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
                                                      '${Languages.of(context).overdue} ',
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
                                                  decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.white),
                                                      borderRadius: BorderRadius.circular(16)),
                                                  padding: const EdgeInsets.all(8),
                                                  child: Text(
                                                    Languages.of(context).active,
                                                    style: white12w400,
                                                  ),
                                                )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'HKD ${GlobalFunction().formattedMoney(isOverdue || totalmustbepaid != null ? totalmustbepaid?.toDouble() : state.data.notbeenpaidof?.toDouble() ?? double.parse(dataLoan!.loanamount!))}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 36,
                                          fontFamily: 'Gabarito',
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        dataLoan?.packageName ?? '',
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
                                        bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
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
                                                  : DateFormat('yyyy-MM-dd').format(state.data.data!.duedate!),
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
                                const SizedBox(
                                  height: 32.0,
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
                                          )
                                        : const SizedBox(),

                                /* 

                                        XXX: Multi-loan
                                        
                                        Container(
                                            width: 350,
                                            height: 60,
                                            padding: const EdgeInsets.all(12),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFF1F2A37),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    width: 1,
                                                    color: Color(0xFFA4CAFE)),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                    Languages.of(context)
                                                        .clearLoanBeforeApplying,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ), */
                                const SizedBox(
                                  height: 32.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF252422), borderRadius: BorderRadius.circular(12)),
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
                                                    idLoan: dataLoan?.id,
                                                    idLoanDetail: dataLoan!.loanPackageDetails!.isNotEmpty
                                                        ? dataLoan?.loanPackageDetails?.last.id
                                                        : 0));
                                          },
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
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
                                const SizedBox(
                                  height: 8.0,
                                ),
                                // BlocConsumer<TransactionBloc, TransactionState>(
                                //   bloc: _transactionBloc,
                                //   listener: (context, state) {
                                //     // TODO: implement listener
                                //   },
                                //   builder: (context, state) {
                                //     if (state is GetListPaymentSuccess) {
                                DoneRepayment(
                                  repaymentBloc: _repaymentBloc,
                                  loanpackgeid: idloan ?? 0,
                                ),

                                //     } else {
                                //       return Container();
                                //     }
                                //   },
                                // )
                                // Row(
                                // ,
                                const SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 145,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                          image: AssetImage('assets/images/promo2.png'), fit: BoxFit.cover)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Languages.of(context).loanBalance,
                                            style: white16w600,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white),
                                                borderRadius: BorderRadius.circular(16)),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                                dataLoan == null
                                                    ? Languages.of(context).noActive
                                                    : Languages.of(context).pending,
                                                style: white12w400),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        'HKD ${dataLoan == null ? 0 : dataLoan?.loanamount}',
                                        style: white24w600,
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      // Text(
                                      //   '${Languages.of(context).returnDay} : ${dataLoan?.returnday ?? ''}',
                                      //   style: white12w600,
                                      // ),
                                      // const SizedBox(
                                      //   height: 5.0,
                                      // ),
                                      Text(
                                        '${Languages.of(context).dateLoan} : ${dataLoan == null ? '' : DateFormat('yyyy-MM-dd').format(dataLoan?.dateloan ?? DateTime.now())}',
                                        style: white12w600,
                                      ),
                                      const SizedBox(
                                        height: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 24.0,
                                ),
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
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * .2,
                                ),
                                Center(
                                  child: Text(
                                    Languages.of(context).noActivities,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                // BlocConsumer<TransactionBloc, TransactionState>(
                                //   bloc: _transactionBloc,
                                //   listener: (context, state) {
                                //     // TODO: implement listener
                                //   },
                                //   builder: (context, state) {
                                //     if (state is GetListPaymentSuccess) {
                                // return
                                // DoneRepayment(
                                //   repaymentBloc: _repaymentBloc,
                                //   loanpackgeid: idloan ?? 0,
                                // ),
                                //     } else {
                                //       return Container();
                                //     }
                                //   },
                                // ),
                                const SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
