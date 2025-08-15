// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/bloc/auth/auth_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/main_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController idNumber = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF000000),
          leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            Languages.of(context).signUp,
            style: GoogleFonts.signika(color: Colors.white),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Color(0xFF000000)),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0 * 2),
                Text(
                  Languages.of(context).createAccount,
                  style: GoogleFonts.signika(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                SizedBox(
                  width: 350,
                  child: Text(
                    Languages.of(context).joinPlatform,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF7D8998),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0 * 2),
                Form(
                  key: formKey,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    bloc: _authBloc,
                    listener: (context, state) {
                      if (state is PostRegisterError) {
                        EasyLoading.dismiss();
                        GlobalFunction().allDialog(
                          context,
                          title: state.message,
                        );
                      } else if (state is PostRegisterSuccess) {
                        EasyLoading.dismiss();
                        GlobalFunction().allDialog(context,
                            title: Languages.of(context).congratulations,
                            subtitle:
                                Languages.of(context).accountCreationSuccess,
                            titleButton: Languages.of(context).continueText,
                            onTap: () {
                          context.pushNamed(login);
                        });
                      }

                      if (state is GetEmailVerificationSuccess) {
                        EasyLoading.dismiss();
                      } else if (state is GetEmailVerificationError) {
                        EasyLoading.dismiss();
                      }
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      final errors =
                          (state is PostRegisterError) ? state.errors : {};

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                Languages.of(context).idCardNumber,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                ' ${Languages.of(context).eg}',
                                style: GoogleFonts.inter(
                                  color: Colors.red[500],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          MainTextFormField(
                            controller: idNumber,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[^\w\s]')),
                            ],
                            errorText:
                                errors?['ic'] != null ? errors!['ic'][0] : null,
                            hintText: Languages.of(context).idCardNumber,
                            onChanged: (value) {
                              // Filter input to remove spaces, special characters, and underscores
                              String filteredValue =
                                  value.replaceAll(RegExp(r'[^\w]|_'), '');
                              if (value != filteredValue) {
                                idNumber.text = filteredValue;
                                idNumber.selection = TextSelection.fromPosition(
                                  TextPosition(offset: filteredValue.length),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
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
                            keyboardType: TextInputType.phone,
                            controller: phoneNumber,
                            validator: (value) {
                              if (value!.length < 8) {
                                return Languages.of(context)
                                    .passwordLengthRequirement;
                              }
                              return null;
                            },
                            errorText: errors?['phone'] != null
                                ? errors!['phone'][0]
                                : null,
                            hintText: Languages.of(context).phoneNumber,
                            onChanged: (value) {
                              // Filter input untuk hanya angka
                              String filteredValue =
                                  value.replaceAll(RegExp(r'[^\d]'), '');
                              if (value != filteredValue) {
                                phoneNumber.text = filteredValue;
                                phoneNumber.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(offset: filteredValue.length),
                                );
                              }
                            },
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          MainButtonGradient(
                            title: state is PostRegisterLoading ||
                                    state is GetEmailVerificationLoading
                                ? '${Languages.of(context).loading}...'
                                : Languages.of(context).register,
                            onTap: state is PostRegisterLoading ||
                                    state is GetEmailVerificationLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      EasyLoading.show(
                                          maskType: EasyLoadingMaskType.black);

                                      _authBloc.add(PostRegisterEvent(
                                          ic: idNumber.text,
                                          phone: phoneNumber.text));
                                    }
                                  },
                          ),
                          const SizedBox(height: 16.0),
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: Languages.of(context)
                                        .alreadyHaveAccount,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF7D8998),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF1F2A37),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: Languages.of(context).login,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => context.pushNamed(login),
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF0972D3),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
