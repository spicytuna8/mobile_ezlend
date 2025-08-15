// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanApplyScreen extends StatefulWidget {
  final ItemPackageIndex data;
  const LoanApplyScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<LoanApplyScreen> createState() => _LoanApplyScreenState();
}

class _LoanApplyScreenState extends State<LoanApplyScreen> {
  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  TransactionBloc transactionBloc = TransactionBloc();
  int activeStep = 0;
  double progress = 0.2;
  bool statusLoanActive = false;
  bool statusLoanPending = false;
  bool isKycApproved = true;
  int loanStatus = 0;
  int status = 0;
  final TransactionBloc _transactionBloc = TransactionBloc();
  List<String> list = [
    "Identity Verification",
    "3-minute Review",
    "3-minute Receival"
  ];

  @override
  void initState() {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    // TODO: implement initState
    super.initState();
    _transactionBloc.add(const GetLoanEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      bloc: _transactionBloc,
      listener: (context, state) {
        if (state is GetLoanError) {
          EasyLoading.dismiss();
        } else if (state is GetLoanSuccess) {
          if (state.data.data!.isNotEmpty) {
            for (var i = 0; i < state.data.data!.length; i++) {
              setState(() {
                loanStatus = state.data.data![i].statusloan ?? 0;
                status = state.data.data![i].status ?? 0;
              });
              if (state.data.data![i].status == 0) {
                setState(() {
                  statusLoanPending = true;
                });
                break;
              } else if (state.data.data![i].status == 3 &&
                  state.data.data![i].statusloan == 4) {
                setState(() {
                  statusLoanActive = true;
                });
              }
            }
          }
          EasyLoading.dismiss();
        }
        // TODO: implement listener
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            Languages.of(context).applyLoan,
            style: black18w600,
          ),
          centerTitle: true,
          actions: const [],
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text('${Languages.of(context).loanAmount} (HKD)',
                          style: black16w600),
                      Text(widget.data.amount.toString(), style: black22w600),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ],
              ),
              Text(Languages.of(context).applicationSteps, style: black16w600),
              const SizedBox(
                height: 20.0,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      itemBuilder: (con, ind) {
                        return ind != 0
                            ? ind == 1
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Row(children: [
                                          Column(
                                            children: List.generate(
                                              5,
                                              (ii) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: Container(
                                                    height: 4,
                                                    width: 2,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            color: Colors.grey.withAlpha(60),
                                            height: 0.5,
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 20,
                                            ),
                                          ))
                                        ]),
                                        Row(children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: baseColor,
                                                shape: BoxShape.circle,
                                                border: Border.all()),
                                            child: const Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(list[ind], style: black14w600)
                                        ])
                                      ])
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        Row(children: [
                                          Column(
                                            children: List.generate(
                                              5,
                                              (ii) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 5,
                                                          bottom: 5),
                                                  child: Container(
                                                    height: 4,
                                                    width: 2,
                                                    color: Colors.grey,
                                                  )),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                            color: Colors.grey.withAlpha(60),
                                            height: 0.5,
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 20,
                                            ),
                                          ))
                                        ]),
                                        Row(children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: baseColor,
                                                shape: BoxShape.circle,
                                                border: Border.all()),
                                            child: const Icon(
                                              Icons.attach_money_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(list[ind], style: black14w600)
                                        ])
                                      ])
                            : Row(children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: baseColor,
                                      shape: BoxShape.circle,
                                      border: Border.all()),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(list[ind], style: black14w600)
                              ]);
                      }),
                ),
              )
              // EasyStepper(
              //   activeStep: activeStep,
              //   enableStepTapping: false,
              //   steppingEnabled: false,
              //   stepRadius: 15,
              //   showTitle: true,
              //   direction: Axis.vertical,
              //   alignment: Alignment.centerLeft,
              //   textDirection: TextDirection.rtl,
              //   padding:
              //       EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 7),
              //   lineStyle: LineStyle(
              //     lineLength: 50,
              //     lineThickness: 1.5,
              //     lineSpace: 4,
              //     lineType: LineType.dotted,
              //     defaultLineColor: Colors.purple.shade300,
              //     // progress: progress,
              //     // progressColor: Colors.purple.shade700,
              //   ),
              //   borderThickness: 10,
              //   internalPadding: 5,
              //   steps: const [
              //     EasyStep(
              //         icon: Icon(CupertinoIcons.cart),
              //         customTitle: Text('dasda'),
              //         title: 'Cart',
              //         customLineWidget: Row(
              //           children: [Icon(CupertinoIcons.cart), Text('dasda')],
              //         )),
              //     EasyStep(
              //       icon: Icon(CupertinoIcons.info),
              //       title: 'Address',
              //       lineText: 'Go To Checkout',
              //     ),
              //     EasyStep(
              //       icon: Icon(CupertinoIcons.cart_fill_badge_plus),
              //       title: 'Checkout',
              //       lineText: 'Choose Payment Method',
              //     ),
              //   ],
              //   onStepReached: (index) => setState(() => activeStep = index),
              // ),
            ],
          ),
        ),
        bottomSheet: BlocConsumer<TransactionBloc, TransactionState>(
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
            return Container(
              margin: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: MainButton(
                title: state is PostLoanLoading
                    ? Languages.of(context).loading
                    : Languages.of(context).applyNow,
                radius: 8,
                onTap: () async {
                  String statusKyc =
                      await preferencesHelper.getStringSharedPref('kyc_status');
                  log("${statusKyc}status kyc");
                  if (statusKyc == '1') {
                    transactionBloc.add(PostLoanEvent(
                      packageId: widget.data.id.toString(),
                      dateLoan: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ));
                  } else if (statusKyc == '0') {
                    GlobalFunction().allDialog(context,
                        title: Languages.of(context).kycLoanPendingApproval);
                  } else if (statusKyc == '2') {
                    GlobalFunction().allDialog(context,
                        title: Languages.of(context).kycRejected);
                  } else {
                    context.pushNamed(kyc1Input, extra: widget.data);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStep(String title, IconData iconData) {
    return Column(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: Stack(
            children: [
              Container(
                width: 1,
                height: 40,
                color: Colors.grey,
              ),
              Positioned(
                top: 40,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    painter: DashLinePainter(),
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class DashLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    const double dashWidth = 5;
    const double dashSpace = 3;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
