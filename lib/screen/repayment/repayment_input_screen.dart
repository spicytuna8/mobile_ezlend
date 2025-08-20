// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/bloc/bank/bank_bloc.dart';
import 'package:loan_project/helper/Image_picker.dart';
import 'package:loan_project/helper/color_helper.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/response_bank_info.dart';
import 'package:loan_project/widget/main_button.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/main_dropdown.dart';
import 'package:loan_project/widget/main_textfield.dart';

class RepaymentInputScreen extends StatefulWidget {
  final RepaymentInputParam data;
  const RepaymentInputScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<RepaymentInputScreen> createState() => _RepaymentInputScreenState();
}

class _RepaymentInputScreenState extends State<RepaymentInputScreen> {
  TextEditingController amount = TextEditingController();
  final BankBloc _bankBloc = BankBloc();
  List<DatumBank> dataBank = [];
  DatumBank? selectedBank;
  int bankSelected = 0;

  String file = '';
  String file64 = '';
  Map<String, dynamic>? selectBank;
  List listMethod = [
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
                Languages.of(context).bankInfo,
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
                Languages.of(context).transferToSpecifiedBank,
                style: GoogleFonts.inter(
                  color: const Color(0xFF7D8998),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              MainDropdown(
                  titleFontSize: 12,
                  title: Languages.of(context).selectMethod,
                  onChanged: (p0) {
                    setState(() {
                      selectBank = p0;
                    });
                  },
                  iconColor: Colors.grey,
                  titleColor: const Color(0xFF7D8998),
                  selectedValue: selectBank,
                  boxDecoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1, color: greyBlackColor)),
                  items: listMethod
                      .map((item) => DropdownMenuItem<Map<String, dynamic>>(
                            value: item,
                            child: Text(
                              item['name'],
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: greyBlackColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                      .toList(),
                  isJustTitle: true),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                Languages.of(context).transferMethod,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              BlocConsumer<BankBloc, BankState>(
                bloc: _bankBloc,
                listener: (context, state) {
                  if (state is GetBankInfoSuccess) {
                    setState(() {
                      state.data.data?.forEach((element) {
                        if (element.type == 'Wire Transfer') {
                          dataBank.add(element);
                        }
                      });
                    });
                  }
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is GetBankInfoLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is GetBankInfoSuccess) {
                    return Container(
                      child: ListView.builder(
                        itemCount: dataBank.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                bankSelected = index;
                                selectedBank = dataBank[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1, color: bankSelected == index ? baseColor : const Color(0xFF354150)),
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
                                            '${dataBank[index].name}',
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
                                            '${dataBank[index].accountName}',
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
                                          '${dataBank[index].accountNumber}',
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
                          );
                        },
                      ),
                    );
                  } else {
                    return MainButton(
                      onTap: () {
                        _bankBloc.add(const GetBankInfoEvent());
                      },
                      title: Languages.of(context).tryAgain,
                    );
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                Languages.of(context).repayment,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                Languages.of(context).transferToSpecifiedBank,
                style: GoogleFonts.inter(
                  color: const Color(0xFF7D8998),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                Languages.of(context).amount,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              MainTextFormField(
                controller: amount,
                hintText: Languages.of(context).amount,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                Languages.of(context).transactionReceipt,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await ImagePickerDialog.pickImage(context);
                  String base64Image = '';

                  if (result != null) {
                    List<int> imageBytes = await result.readAsBytes();
                    setState(() {
                      file = result.path;
                      base64Image = base64Encode(imageBytes);
                      file64 = 'data:image/png;base64,$base64Image';
                      // log(" ini foto front " + file64.toString());
                    });
                  }
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(8),
                  dashPattern: const [5, 5],
                  color: const Color(0xFF354150),
                  strokeWidth: 1,
                  child: file == ''
                      ? SizedBox(
                          height: 133,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                color: Color(0xFF354150),
                                size: 50,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                Languages.of(context).tapHereToUpload,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF7D8998),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                Languages.of(context).fileFormatLimit,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF7D8998),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 133,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(File(file)),
                        ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              // BlocConsumer<TransactionBloc, TransactionState>(
              //   bloc: _transactionBloc,
              //   listener: (context, state) {
              //     if (state is PostPaidSuccess) {
              //       _transactionBloc.add(PostPaidWithFileEvent(
              //           data: RequestPaidWithFile(
              //               topup: Topup(
              //                   amount: int.parse(amount.text),
              //                   paymentId: dataBank[0].id),
              //               topupFile: [TopupFile(file: file64)])));
              //     } else if (state is PostPaidWithFileSuccess) {
              //       GlobalFunction().allDialog(context,
              //           title: 'Succes, it s Paid off', onTap: () {
              //         context.pushReplacementNamed(bottomNavigation, extra: 0);
              //       });
              //     } else if (state is PostPaidWithFileError) {
              //       GlobalFunction().allDialog(context, title: state.message);
              //     } else if (state is PostPaidError) {
              //       GlobalFunction().allDialog(
              //         context,
              //         title: state.message,
              //       );
              //     }
              //     // TODO: implement listener
              //   },
              //   builder: (context, state) {
              //     return
              ValueListenableBuilder(
                  valueListenable: amount,
                  builder: (context, value, _) {
                    return MainButtonGradient(
                      title: Languages.of(context).continueText,
                      onTap: amount.text.isEmpty || file.isEmpty || selectBank == null
                          ? null
                          : () {
                              context.pushNamed(repaymentSummary,
                                  extra: RepaymentParam(
                                      idLoan: widget.data.idLoan.toString(),
                                      idLoanDetail: widget.data.idLoanDetail.toString(),
                                      file: file64,
                                      amount: int.parse(amount.text),
                                      selectedMethod: selectBank ?? {},
                                      dataBank: dataBank[bankSelected]));
                              // _transactionBloc.add(PostPaidEvent(
                              //     loanpackageId: widget.id.toString(),
                              //     amount: int.parse(amount.text)));
                            },
                    );
                  })
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}

class RepaymentParam {
  final String idLoan;
  final String idLoanDetail;
  final String file;
  final int amount;
  final Map<String, dynamic> selectedMethod;
  final DatumBank dataBank;

  RepaymentParam({
    required this.idLoan,
    required this.idLoanDetail,
    required this.file,
    required this.amount,
    required this.selectedMethod,
    required this.dataBank,
  });
}

class RepaymentInputParam {
  final int? idLoan;
  final int? idLoanDetail;

  RepaymentInputParam({this.idLoan, this.idLoanDetail});
}
