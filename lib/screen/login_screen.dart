// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/bloc/auth/auth_bloc.dart';
import 'package:loan_project/helper/constants.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/locale_constants.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/main_textfield.dart';
import 'package:loan_project/widget/rounded_container.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PreferencesHelper _preferencesHelper = PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  final AuthBloc _authBloc = AuthBloc();
  TextEditingController idNumber = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  FocusNode phoneFcs = FocusNode();
  FocusNode idNumberFcs = FocusNode();
  String phone = '';
  String value = '';
  String selectedValue = 'Option 1';
  int indexSelected = 0;
  PackageInfo? _packageInfo;

  bool isContainerVisible = false;

  void toggleContainer() {
    setState(() {
      isContainerVisible = !isContainerVisible;
    });
  }

  Future<void> getLanguage() async {
    value = await _preferencesHelper.getStringSharedPref(prefSelectedLanguageCode);
    int index = language.indexWhere((element) => value == element['id']);
    if (index == -1) {
      indexSelected = indexSelected;
    } else {
      indexSelected = index;
    }

    setState(() {});
  }

  Future<void> getLatest() async {
    _packageInfo = await PackageInfo.fromPlatform();

    // if (!kIsWeb) {
    //   _appReleaseBloc.add(GetLatest(packageName: _packageInfo!.packageName));
    // }
    setState(() {});
  }

  @override
  void initState() {
    getLanguage();
    getLatest();

    // Prefilled credentials for debugging only
    if (kDebugMode) {
      idNumber.text = 'A1234567';
      phoneNumber.text = '1234567890';
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/bg_login.png'), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Positioned(
                top: 40,
                right: 25,
                child: Center(
                  child: Text(
                    _packageInfo?.version ?? '',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )),
            Positioned(
              width: MediaQuery.sizeOf(context).width,
              height: 80,
              top: 230,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 14),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  Languages.of(context).speedyLoans,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.signika(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            isContainerVisible
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipPath(
                          clipper: RoundedDiagonalClipper(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
                              color: Color(0xff252422),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                BlocConsumer<AuthBloc, AuthState>(
                                  bloc: _authBloc,
                                  listener: (context, state) {
                                    if (state is PostLoginError) {
                                      EasyLoading.dismiss();
                                    } else if (state is PostLoginSuccess) {
                                      _preferencesHelper.setStringSharedPref('token', state.data.token ?? '');
                                      _preferencesHelper.setStringSharedPref('id', idNumber.text);
                                      _preferencesHelper.setStringSharedPref('phone', phone);
                                      EasyLoading.dismiss();
                                      context.pushNamed(bottomNavigation, extra: 0);
                                    }
                                    // TODO: implement listener
                                  },
                                  builder: (context, state) {
                                    final errors = (state is PostLoginError) ? state.errors : {};

                                    return Form(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
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
                                            focusNode: idNumberFcs,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]')),
                                            ],
                                            errorText: errors?['ic'] != null ? errors!['ic'][0] : null,
                                            // label: const Text('ID number'),
                                            hintText: Languages.of(context).idCardNumber,
                                            onChanged: (value) {
                                              // Filter input to remove spaces, special characters, and underscores
                                              String filteredValue = value.replaceAll(RegExp(r'[^\w]|_'), '');
                                              if (value != filteredValue) {
                                                idNumber.text = filteredValue;
                                                idNumber.selection = TextSelection.fromPosition(
                                                  TextPosition(offset: filteredValue.length),
                                                );
                                              }
                                            },

                                            onTap: () {
                                              setState(() {
                                                isContainerVisible = false;
                                              });
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
                                            errorText: errors?['phone'] != null ? errors!['phone'][0] : null,
                                            controller: phoneNumber,
                                            focusNode: phoneFcs,
                                            keyboardType: TextInputType.phone,
                                            // prefixIcon: const Padding(
                                            //   padding: EdgeInsets.only(
                                            //       left: 12.0, right: 5, bottom: 5),
                                            //   child: Text(
                                            //     '+852 ',
                                            //     style: TextStyle(
                                            //         color: Colors.white, fontSize: 14),
                                            //   ),
                                            // ),
                                            validator: (value) {
                                              if (value!.length < 8) {
                                                return 'Must be at least 8 digits';
                                              }
                                              return null;
                                            },
                                            hintText: Languages.of(context).phoneNumber,
                                            onChanged: (value) {
                                              // Filter input to remove spaces, special characters, and underscores
                                              String filteredValue = value.replaceAll(RegExp(r'[^\w]|_'), '');
                                              if (value != filteredValue) {
                                                idNumber.text = filteredValue;
                                                idNumber.selection = TextSelection.fromPosition(
                                                  TextPosition(offset: filteredValue.length),
                                                );
                                              }
                                            },

                                            onTap: () {
                                              setState(() {
                                                isContainerVisible = false;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 16.0),
                                          MainButtonGradient(
                                            title: state is PostLoginLoading
                                                ? '${Languages.of(context).loading}...'

                                                /// Belum
                                                : Languages.of(context).login,
                                            onTap: state is PostLoginLoading
                                                ? null
                                                : () {
                                                    setState(() {
                                                      isContainerVisible = false;
                                                    });

                                                    EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                                    // if (phoneNumber.text.startsWith('0')) {
                                                    //   setState(() {
                                                    //     phone = phoneNumber.text.substring(1);
                                                    //   });
                                                    //   log(phone.toString());
                                                    // } else {
                                                    // phone = phoneNumber.text;
                                                    // }
                                                    _authBloc.add(
                                                        PostLoginEvent(ic: idNumber.text, phone: phoneNumber.text));
                                                  },
                                          ),
                                          const SizedBox(height: 16.0),
                                          Center(
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: Languages.of(context).dontHaveAccount,
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
                                                    text: Languages.of(context).signUpNow,
                                                    recognizer: TapGestureRecognizer()
                                                      ..onTap = () {
                                                        setState(() {
                                                          isContainerVisible = false;
                                                        });
                                                        context.pushNamed(register);
                                                      },
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
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
                : const SizedBox(),
            Positioned(
              width: MediaQuery.sizeOf(context).width,
              top: 3,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          scale: 20,
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Text(
                          'EZ',
                          style: GoogleFonts.signika(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: toggleContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            language[indexSelected]['image'],
                            width: 19,
                            height: 19,
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            '${language[indexSelected]['name']}',
                            style: white14w400,
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Image.asset(
                            'assets/icons/ic_arrow-down.png',
                            width: 20,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    if (isContainerVisible)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            width: 200,
                            duration: const Duration(seconds: 1),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    language.length,
                                    (index) => GestureDetector(
                                          onTap: () => setState(() {
                                            indexSelected = index;
                                            isContainerVisible = !isContainerVisible;
                                            changeLanguage(context, language[index]['id']);
                                          }),
                                          child: _cardSorting(
                                            index: index,
                                            title: language[index]['name'],
                                            image: language[index]['image'],
                                          ),
                                        ))),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),

            // if (isContainerVisible)
          ],
        ),
      ),
      bottomSheet: !isContainerVisible
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipPath(
                  clipper: RoundedDiagonalClipper(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
                      color: Color(0xff252422),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        BlocConsumer<AuthBloc, AuthState>(
                          bloc: _authBloc,
                          listener: (context, state) {
                            if (state is PostLoginError) {
                              EasyLoading.dismiss();
                            } else if (state is PostLoginSuccess) {
                              _preferencesHelper.setStringSharedPref('token', state.data.token ?? '');
                              _preferencesHelper.setStringSharedPref('id', idNumber.text);
                              _preferencesHelper.setStringSharedPref('phone', phone);
                              EasyLoading.dismiss();
                              context.pushNamed(bottomNavigation, extra: 0);
                            }
                            // TODO: implement listener
                          },
                          builder: (context, state) {
                            final errors = (state is PostLoginError) ? state.errors : {};

                            return Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    focusNode: idNumberFcs,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'[^\w\s]')),
                                    ],
                                    errorText: errors?['ic'] != null ? errors!['ic'][0] : null,
                                    // label: const Text('ID number'),
                                    hintText: Languages.of(context).idCardNumber,

                                    onChanged: (value) {
                                      // Filter input to remove spaces, special characters, and underscores
                                      String filteredValue = value.replaceAll(RegExp(r'[^\w]|_'), '');
                                      if (value != filteredValue) {
                                        idNumber.text = filteredValue;
                                        idNumber.selection = TextSelection.fromPosition(
                                          TextPosition(offset: filteredValue.length),
                                        );
                                      }
                                    },

                                    onTap: () {
                                      setState(() {
                                        isContainerVisible = false;
                                      });
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
                                    errorText: errors?['phone'] != null ? errors!['phone'][0] : null,
                                    controller: phoneNumber,
                                    focusNode: phoneFcs,
                                    keyboardType: TextInputType.phone,

                                    // prefixIcon: const Padding(
                                    //   padding: EdgeInsets.only(
                                    //       left: 12.0, right: 5, bottom: 5),
                                    //   child: Text(
                                    //     '+852 ',
                                    //     style: TextStyle(
                                    //         color: Colors.white, fontSize: 14),
                                    //   ),
                                    // ),
                                    validator: (value) {
                                      if (value!.length < 8) {
                                        return 'Must be at least 8 digits';
                                      }
                                      return null;
                                    },

                                    hintText: Languages.of(context).phoneNumber,
                                    onChanged: (value) {
                                      // Filter input untuk hanya angka
                                      String filteredValue = value.replaceAll(RegExp(r'[^\d]'), '');
                                      if (value != filteredValue) {
                                        phoneNumber.text = filteredValue;
                                        phoneNumber.selection = TextSelection.fromPosition(
                                          TextPosition(offset: filteredValue.length),
                                        );
                                      }
                                    },
                                    onTap: () {
                                      setState(() {
                                        isContainerVisible = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  MainButtonGradient(
                                    title: state is PostLoginLoading
                                        ? '${Languages.of(context).loading}...'

                                        /// Belum
                                        : Languages.of(context).login,
                                    onTap: state is PostLoginLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              isContainerVisible = false;
                                            });

                                            EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                            // if (phoneNumber.text.startsWith('0')) {
                                            //   setState(() {
                                            //     phone = phoneNumber.text.substring(1);
                                            //   });
                                            //   log(phone.toString());
                                            // } else {
                                            // phone = phoneNumber.text;
                                            // }
                                            _authBloc.add(PostLoginEvent(ic: idNumber.text, phone: phoneNumber.text));
                                          },
                                  ),
                                  const SizedBox(height: 16.0),
                                  Center(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: Languages.of(context).dontHaveAccount,
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
                                            text: Languages.of(context).signUpNow,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  isContainerVisible = false;
                                                });
                                                context.pushNamed(register);
                                              },
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
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox(),
    );
  }

  Container _cardSorting({String? title, String? image, void Function()? onPressed, required int index}) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: const Border(
          top: BorderSide(width: 0.5, color: Color(0xFFB9B9B9)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                image ?? '',
                width: 19,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(title ?? 'English', style: black14w400),
            ],
          ),
          indexSelected == index
              ? IconButton(
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: onPressed ?? () {},
                  icon: const Icon(
                    Icons.done,
                    color: Color(0xff007AFF),
                  ))
              : Container()
        ],
      ),
    );
  }
}
