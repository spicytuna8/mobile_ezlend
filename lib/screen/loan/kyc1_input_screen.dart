// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loan_project/bloc/bank/bank_bloc.dart';
import 'package:loan_project/bloc/kyc/kyc_bloc.dart';
import 'package:loan_project/bloc/member/member_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/model/kyc2_param.dart';
import 'package:loan_project/model/response_bank_info.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/model/response_relationship.dart';
import 'package:loan_project/screen/loan/kyc2_input_screen.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/main_dropdown.dart';
import 'package:loan_project/widget/main_textfield.dart';
import 'package:video_player/video_player.dart';

class Kyc1InputScreen extends StatefulWidget {
  final ItemPackageIndex nominal;
  const Kyc1InputScreen({Key? key, required this.nominal}) : super(key: key);

  @override
  State<Kyc1InputScreen> createState() => _Kyc1InputScreenState();
}

class _Kyc1InputScreenState extends State<Kyc1InputScreen> {
  final KycBloc kycBloc = KycBloc();
  final MemberBloc memberBloc = MemberBloc();
  final BankBloc bankBloc = BankBloc();
  final TransactionBloc transactionBloc = TransactionBloc();
  TextEditingController namePerId = TextEditingController();
  TextEditingController idNumber = TextEditingController();
  TextEditingController benefiaryName = TextEditingController();
  TextEditingController benefiaryContact = TextEditingController();
  TextEditingController beneficiaryRelationship = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController accountName = TextEditingController();
  TextEditingController accountNumber = TextEditingController();

  int activeStep = 0;
  double progress = 0.2;
  String file = '';
  String fileFront = '';
  String fileFront64 = '';
  String fileBack = '';
  String fileBack64 = '';
  String fileSelfie = '';
  String fileSelfie64 = '';
  List<DatumBank> listBankUser = [];
  List<ResponseGetRelationship> listRelationshipD = [];
  DatumBank? selectedBankUser;
  ResponseGetRelationship? selectedRelationship;
  final formKey = GlobalKey<FormState>();

  // Map<String, dynamic>? selectedRelationship;

  VideoPlayerController? _controller;
  bool initialized = false;
  bool showErrorBank = false;
  bool showErrorRelationship = false;

  @override
  void initState() {
    memberBloc.add(GetRelationshipEvent());
    bankBloc.add(const GetBankInfoEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TransactionBloc, TransactionState>(
          bloc: transactionBloc,
          listener: (context, state) {
            if (state is PostLoanSuccess) {
              EasyLoading.dismiss();
              GlobalFunction().allDialog(context,
                  title: Languages.of(context).successSubmitKycAndApplyLoan,
                  onTap: () {
                context.pushReplacementNamed(bottomNavigation, extra: 0);
              });
            } else if (state is PostLoanError) {
              EasyLoading.dismiss();
              GlobalFunction().allDialog(
                context,
                title: state.message,
              );
            }
            // TODO: implement listener
          },
        ),
        BlocListener<MemberBloc, MemberState>(
          bloc: memberBloc,
          listener: (context, state) {
            if (state is GetRelationshipSuccess) {
              setState(() {
                listRelationshipD = state.data;
              });
            } else if (state is GetRelationshipError) {
              log('error get relationship ${state.message}');
            }
            // TODO: implement listener
          },
        ),
        BlocListener<BankBloc, BankState>(
          bloc: bankBloc,
          listener: (context, state) {
            if (state is GetBankInfoSuccess) {
              setState(() {
                state.data.data?.forEach((element) {
                  if (element.type == 'Bank Info(User)') {
                    listBankUser.add(element);
                  }
                });
              });
            } else if (state is GetBankInfoError) {}
            // TODO: implement listener
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          title: Text(
            Languages.of(context).applyLoan,
            style: white18w600,
          ),
          centerTitle: true,
          actions: const [],
        ),
        body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: BlocConsumer<KycBloc, KycState>(
              bloc: kycBloc,
              listener: (context, state) {
                if (state is PostKycSuccess) {
                  // EasyLoading.dismiss();
                  transactionBloc.add(PostLoanEvent(
                    packageId: widget.nominal.id.toString(),
                    dateLoan: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  ));
                } else if (state is PostKycError) {
                  EasyLoading.dismiss();
                  final errors = state.errors;
                  log('${errors}error kyc');
                  if (errors?['KycFile[1][file]'] != null ||
                      errors?["KycFile[0][file]"] != null ||
                      errors?['KycFile[2][file]'] != null) {
                    GlobalFunction().allDialog(context,
                        title: Languages.of(context).fileTooLarge);
                  } else {
                    GlobalFunction().allDialog(context, title: state.message);
                  }
                }
                // TODO: implement listener
              },
              builder: (context, state) {
                final errors = (state is PostKycError) ? state.errors : {};
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).personalInformation,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        Languages.of(context).dataPrivacyProtection,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7D8998),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        Languages.of(context).nameAsPerId,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: namePerId,
                        hintText: Languages.of(context).nameAsPerId,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).idCardNumber,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: idNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]')),
                        ],
                        hintText: Languages.of(context).idCardNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        Languages.of(context).emergencyContact,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        Languages.of(context).relativesContactExplanation,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF7D8998),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        Languages.of(context).relationship,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainDropdown(
                          titleFontSize: 14,
                          title: Languages.of(context).selectRelationship,
                          onChanged: (p0) {
                            setState(() {
                              selectedRelationship = p0;
                            });
                          },
                          iconColor: Colors.grey,
                          titleColor: const Color(0xFF7D8998),
                          selectedValue: selectedRelationship,
                          boxDecoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: showErrorRelationship
                                      ? Colors.red
                                      : const Color(0xFF354150))),
                          items: listRelationshipD
                              .map((item) =>
                                  DropdownMenuItem<ResponseGetRelationship>(
                                    value: item,
                                    child: Text(
                                      GlobalFunction().translateRelationship(
                                          context, item.name),
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          isJustTitle: true),
                      if (showErrorRelationship)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 10),
                          child: Text(
                            Languages.of(context).pleaseSelectRelationship,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).name,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: benefiaryName,
                        hintText: Languages.of(context).name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).phoneNumber,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: benefiaryContact,
                        hintText: Languages.of(context).phoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).bankAccountDetails,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        Languages.of(context).bankName,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainDropdown(
                          titleFontSize: 14,
                          title: Languages.of(context).selectBank,
                          onChanged: (p0) {
                            setState(() {
                              selectedBankUser = p0;
                            });
                          },
                          iconColor: Colors.grey,
                          titleColor: const Color(0xFF7D8998),
                          selectedValue: selectedBankUser,
                          boxDecoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  width: 1,
                                  color: showErrorBank
                                      ? Colors.red
                                      : const Color(0xFF354150))),
                          items: listBankUser
                              .map((item) => DropdownMenuItem<DatumBank>(
                                    value: item,
                                    child: Text(
                                      item.name ?? '',
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          isJustTitle: true),
                      if (showErrorBank)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 10),
                          child: Text(
                            Languages.of(context).pleaseSelectBank,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).bankAccountHolder,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: accountName,
                        hintText: Languages.of(context).bankAccountHolder,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Languages.of(context).bankAccountNumber,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      MainTextFormField(
                        controller: accountNumber,
                        hintText: Languages.of(context).bankAccountNumber,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Languages.of(context).fieldIsRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      MainButtonGradient(
                          title: Languages.of(context).next,
                          onTap: () {
                            setState(() {
                              // Set showErrorBank ke true jika dropdown belum dipilih saat tombol ditekan
                              showErrorBank = selectedBankUser == null;
                              showErrorRelationship =
                                  selectedRelationship == null;
                            });
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              context.pushNamed(kyc2Input,
                                  extra: Kyc2Param(
                                      itemPackage: widget.nominal,
                                      namePerId: namePerId.text,
                                      idNumber: idNumber.text,
                                      benefiaryName: benefiaryName.text,
                                      benefiaryContact: benefiaryContact.text,
                                      beneficiaryRelationship:
                                          selectedRelationship?.name,
                                      bankName: selectedBankUser?.name,
                                      accountName: accountName.text,
                                      accountNumber: accountNumber.text));
                            }
                          })
                    ],
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
