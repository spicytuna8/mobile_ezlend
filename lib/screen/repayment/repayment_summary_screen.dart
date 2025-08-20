import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_project/bloc/bank/bank_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/request_paid_with_file.dart';
import 'package:loan_project/model/response_bank_info.dart';
import 'package:loan_project/screen/repayment/repayment_input_screen.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';

class RepaymentSummaryScreen extends StatefulWidget {
  final RepaymentParam data;
  const RepaymentSummaryScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<RepaymentSummaryScreen> createState() => _RepaymentSummaryScreenState();
}

class _RepaymentSummaryScreenState extends State<RepaymentSummaryScreen> {
  TextEditingController amount = TextEditingController();
  final TransactionBloc _transactionBloc = TransactionBloc();
  final BankBloc _bankBloc = BankBloc();
  List<DatumBank> dataBank = [];

  String file = '';
  String file64 = '';
  Map<String, dynamic>? selectBank;
  List listMethod = [
    {'id': 1, 'name': 'Manual Banking'},
    {'id': 2, 'name': 'Wire Transfer'}
  ];

  @override
  void initState() {
    _bankBloc.add(const GetBankInfoEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          Languages.of(context).repaymentForm,
          style: white18w600,
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Languages.of(context).summary,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Gabarito',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                Languages.of(context).repaymentTransactionDetails,
                style: const TextStyle(
                  color: Color(0xFF7D8998),
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFF354150)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Languages.of(context).bankName,
                            style: greyBlack14w400,
                          ),
                          Flexible(
                            child: Text(
                              '${widget.data.dataBank.name}',
                              textAlign: TextAlign.end,
                              style: white14w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Languages.of(context).accountHolderName,
                            style: greyBlack14w400,
                          ),
                          Flexible(
                            child: Text(
                              '${widget.data.dataBank.accountName}',
                              textAlign: TextAlign.end,
                              style: white14w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Languages.of(context).accountNumber,
                            style: greyBlack14w400,
                          ),
                          Text(
                            '${widget.data.dataBank.accountNumber}',
                            style: white14w600,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Languages.of(context).amount,
                            style: greyBlack14w400,
                          ),
                          Text(
                            '${widget.data.amount}',
                            style: white14w600,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              BlocConsumer<TransactionBloc, TransactionState>(
                bloc: _transactionBloc,
                listener: (context, state) {
                  if (state is PostPaidSuccess) {
                    _transactionBloc.add(PostPaidWithFileEvent(
                        data: RequestPaidWithFile(
                            topup: Topup(
                                loanPackageDetailId: state.data?.data?.loanPackageDetailId,
                                paymentId: widget.data.dataBank.id),
                            topupFile: [TopupFile(file: widget.data.file)])));
                  } else if (state is PostPaidWithFileSuccess) {
                    log('masuk sini yi');

                    GlobalFunction().allDialog(context,
                        title: Languages.of(context).thankYou,
                        subtitle: Languages.of(context).thankYouForPaymentReview, onTap: () {
                      context.pushReplacementNamed(bottomNavigation, extra: 0);
                    });
                  } else if (state is PostPaidWithFileError) {
                    GlobalFunction().allDialog(context, title: state.message);
                  } else if (state is PostPaidError) {
                    GlobalFunction().allDialog(
                      context,
                      title: state.message,
                    );
                  }

                  // TODO: implement listener
                },
                builder: (context, state) {
                  return ValueListenableBuilder(
                      valueListenable: amount,
                      builder: (context, value, _) {
                        return MainButtonGradient(
                          title: state is PostPaidLoading || state is PostPaidWithFileLoading
                              ? '${Languages.of(context).loading}...'
                              : Languages.of(context).submit,
                          onTap: () {
                            _transactionBloc.add(PostPaidEvent(
                                loanpackageId: widget.data.idLoan.toString(), amount: widget.data.amount));
                          },
                        );
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
