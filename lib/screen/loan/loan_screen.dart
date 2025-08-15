// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({Key? key}) : super(key: key);

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen> {
  final TransactionBloc _transactionBloc = TransactionBloc();
  DatumLoan? dataLoan;
  ResponseGetLoan? dataHistory;
  bool isHaveData = true;

  @override
  void initState() {
    super.initState();
    _transactionBloc.add(const GetLoanEvent(status: 4));
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
                  dataLoan = element;
                  // if (dataLoan != null) {
                  _transactionBloc
                      .add(CheckLoanEvent(packageId: dataLoan!.id.toString()));
                  // }
                  isHaveData = false;
                });
              } else {
                setState(() {
                  dataLoan = element;
                  isHaveData = false;
                });
              }
            });
          } else if (state.data.data!.isEmpty) {
            setState(() {
              dataLoan = null;
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
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          title: Text(
            Languages.of(context).loan,
            style: white16w600,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: isHaveData
              ? const Center(
                  child: RefreshProgressIndicator(),
                )
              : dataLoan == null
                  ? Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      child: Card(
                        color: baseColor,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                Languages.of(context).youDontHaveActiveLoan,
                                style: white14w400,
                              ),
                              // TextButton(
                              //     onPressed: () {
                              //       context.pushNamed(paidScreen,
                              //           extra: dataLoan?.id);
                              //     },
                              //     child: Text(
                              //       'Pay Now',
                              //       style: white14w800,
                              //     ))
                            ],
                          ),
                        ),
                      ),
                    )
                  : BlocConsumer<TransactionBloc, TransactionState>(
                      bloc: _transactionBloc,
                      listener: (context, state) {
                        if (state is CheckLoanSuccess) {}
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        if (state is CheckLoanSuccess) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 145,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Languages.of(context).currentLoan,
                                            style: black16w600,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              Languages.of(context).active,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'HKD ${state.data.loanamount ?? dataLoan?.loanamount ?? 0}',
                                        style: black24w600,
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        '${Languages.of(context).alreadyPaid} : HKD ${state.data.alreadypaid == null ? state.data.data?.alreadypaid ?? '' : state.data.alreadypaid ?? ''}',
                                        style: green12w600,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Visibility(
                                          visible:
                                              state.data.notbeenpaidof != null,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${Languages.of(context).notBeenPaidOf} : HKD ${state.data.notbeenpaidof ?? '0'}',
                                                    style: TextStyle(
                                                        color: Colors.red[600],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 16.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Visibility(
                                          visible: state
                                                  .data.data?.totalmustbepaid !=
                                              null,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${Languages.of(context).totalMustBePaid} : HKD ${state.data.data?.totalmustbepaid}',
                                                    style: TextStyle(
                                                        color: Colors.red[600],
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  const SizedBox(
                                                    width: 16.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${Languages.of(context).returnDay} : ${dataLoan?.returnday ?? ''}',
                                        style: black12w600,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${Languages.of(context).dateLoan} : ${DateFormat('yyyy-MM-dd').format(dataLoan?.dateloan ?? DateTime.now())}',
                                        style: black12w600,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(repaymentInput,
                                              extra: dataLoan?.id);
                                          // _transactionBloc.add(const PostPaidEvent(
                                          //     loanpackageId: '10', amount: 200));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(Languages.of(context).payNow),
                                            Icon(Icons.arrow_outward_outlined)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  // height: 145,
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Languages.of(context).currentLoan,
                                            style: black16w600,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                                Languages.of(context).pending),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                      Text(
                                        'HKD ${dataLoan?.loanamount}',
                                        style: black24w600,
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        '${Languages.of(context).returnDay} : ${dataLoan?.returnday ?? ''}',
                                        style: black12w600,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        '${Languages.of(context).dateLoan} : ${DateFormat('yyyy-MM-dd').format(dataLoan?.dateloan ?? DateTime.now())}',
                                        style: black12w600,
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       'HKD ${dataLoan.notbeenpaidof}',
                                      //       style: red12w600,
                                      //     ),
                                      //     const SizedBox(
                                      //       width: 16.0,
                                      //     ),
                                      //     Text(
                                      //       'HKD ${dataLoan.alreadypaid}',
                                      //       style: green12w600,
                                      //     )
                                      //   ],
                                      // ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     context.pushNamed(paidScreen,
                                      //         extra: dataLoan?.id);
                                      //     // _transactionBloc.add(const PostPaidEvent(
                                      //     //     loanpackageId: '10', amount: 200));
                                      //   },
                                      //   child: const Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.end,
                                      //     children: [
                                      //       Text('Pay Now'),
                                      //       Icon(Icons.arrow_outward_outlined)
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
        ),
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: const Color(0xffF7F1E5),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Languages.of(context).activity,
                style: black20w600,
              ),
              const SizedBox(
                height: 20.0,
              ),
              dataLoan != null
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: dataLoan?.loanPackageDetails?.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                  "HKD ${dataLoan?.loanPackageDetails?[index].amount}"),
                              subtitle: Text(
                                  "${dataLoan?.loanPackageDetails?[index].createdAt}"),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
