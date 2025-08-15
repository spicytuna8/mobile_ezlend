// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/bloc/member/member_bloc.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MemberBloc memberBloc = MemberBloc();
  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  String id = '';
  String phone = '';
  String statusKyc = '0';
  String statusKyc1 = '';
  String statusKyc2 = '';
  String statusKyc3 = '';
  String phoneService = '';
  String url = "https://wa.me/?text=Hello";

  void getId() async {
    id = await preferencesHelper.getStringSharedPref('id');
    phone = await preferencesHelper.getStringSharedPref('phone');
    phoneService = await preferencesHelper.getStringSharedPref('phone_service');
    url = "https://wa.me/$phoneService?text=";

    setState(() {});
  }

  void getKycStatus() async {
    statusKyc = await preferencesHelper.getStringSharedPref('kyc_status');
    statusKyc1 = await preferencesHelper.getStringSharedPref('kyc_status1');
    statusKyc2 = await preferencesHelper.getStringSharedPref('kyc_status2');
    statusKyc3 = await preferencesHelper.getStringSharedPref('kyc_status3');
    if (statusKyc1 == '2' || statusKyc2 == '2' || statusKyc3 == '2') {
      statusKyc = '2';
    } else if (statusKyc1 == '0' || statusKyc2 == '0' || statusKyc3 == '0') {
      statusKyc = '0';
    } else if (statusKyc1 == '' || statusKyc2 == '' || statusKyc3 == '') {
      statusKyc = '';
    } else {
      statusKyc == '1';
    }
    log('${await preferencesHelper.getStringSharedPref('kyc_status1')}statuss kyc');
    setState(() {});
  }

  @override
  void initState() {
    getId();
    getKycStatus();
    memberBloc.add(GetMemberEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff000000),
        appBar: AppBar(
          // title: Text(Languages.of(context).profile),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                Languages.of(context).profile,
                style: white18w800,
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            memberBloc.add(GetMemberEvent());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/profile.png'))),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 4, color: Colors.white)),
                            child: const CircleAvatar(
                              backgroundColor: Color(0xFFBBC0C3),
                              radius: 50,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xff626A72),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            id,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF354150)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Languages.of(context).phoneNumber,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF7D8998),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '+$phone',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                BlocConsumer<MemberBloc, MemberState>(
                                  bloc: memberBloc,
                                  listener: (context, state) {
                                    if (state is GetMemberSuccess) {
                                      log('sukses get member ${state.data.data?.toJson().toString()}');
                                      int kyc1Status = -1;
                                      int kyc2Status = -1;
                                      int kyc3Status = -1;
                                      if (state.data.data?.kyc?['1'] == null ||
                                          state.data.data?.kyc?['2'] == null ||
                                          state.data.data?.kyc?['3'] == null) {
                                        kyc1Status = -1;
                                        kyc2Status = -1;
                                        kyc3Status = -1;
                                      } else {
                                        kyc1Status = state.data.data?.kyc?['1']
                                            ['status'];
                                        kyc2Status = state.data.data?.kyc?['2']
                                            ['status'];
                                        kyc3Status = state.data.data?.kyc?['3']
                                            ['status'];
                                      }
                                      preferencesHelper.setStringSharedPref(
                                          'kyc_status',
                                          state.data.data!.status!.toString());
                                      if (kyc1Status == -1 ||
                                          kyc2Status == -1 ||
                                          kyc3Status == -1) {
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status1', '');
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status2', '');
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status3', '');
                                      } else {
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status1',
                                            state.data.data?.kyc?['1']['status']
                                                    .toString() ??
                                                '');
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status2',
                                            state.data.data?.kyc?['2']['status']
                                                    .toString() ??
                                                '');
                                        preferencesHelper.setStringSharedPref(
                                            'kyc_status3',
                                            state.data.data?.kyc?['3']['status']
                                                    .toString() ??
                                                '');
                                      }
                                      getKycStatus();
                                    } else if (state is GetMemberError) {
                                      log('statuss error ${state.message}');
                                    }
                                    // TODO: implement listener
                                  },
                                  builder: (context, state) {
                                    if (state is GetMemberLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state is GetMemberSuccess) {
                                      return Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration: const ShapeDecoration(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignCenter,
                                                  color: Color(0xFF354150),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Languages.of(context).kycStatus,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF7D8998),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                statusKyc.isEmpty
                                                    ? ''
                                                    : GlobalFunction()
                                                        .getStatusKyc(
                                                            int.parse(
                                                                statusKyc),
                                                            context),
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFFF88A01),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Languages.of(context)
                                                    .idPhotoFront,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF7D8998),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              statusKyc2 == '2'
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        GlobalFunction()
                                                            .rejectCodeKycDialog(
                                                                context,
                                                                subtitle: state
                                                                        .data
                                                                        .data
                                                                        ?.kyc?['2']
                                                                    [
                                                                    'rejected_code']);
                                                        // context.pushNamed(
                                                        //     kyc2Input,
                                                        //     extra: Kyc2Param(
                                                        //         isRejected:
                                                        //             true,
                                                        //         statusKyc1:
                                                        //             statusKyc1 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false,
                                                        //         statusKyc2:
                                                        //             statusKyc2 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false,
                                                        //         statusKyc3:
                                                        //             statusKyc3 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false));
                                                      },
                                                      child: SizedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              Languages.of(
                                                                      context)
                                                                  .reject,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Color(
                                                                    0xFFE02424),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                // GlobalFunction().rejectCodeKycDialog(
                                                                //     context,
                                                                //     subtitle: state
                                                                //             .data
                                                                //             .data
                                                                //             ?.kyc?['2']
                                                                //         [
                                                                //         'rejected_code']);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/ic_info_danger.png',
                                                                width: 17,
                                                                height: 17,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      statusKyc2.isEmpty
                                                          ? ''
                                                          : GlobalFunction()
                                                              .getStatusKyc(
                                                                  int.parse(
                                                                      statusKyc2),
                                                                  context),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Languages.of(context)
                                                    .idPhotoBack,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF7D8998),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              statusKyc3 == '2'
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        GlobalFunction()
                                                            .rejectCodeKycDialog(
                                                                context,
                                                                subtitle: state
                                                                        .data
                                                                        .data
                                                                        ?.kyc?['3']
                                                                    [
                                                                    'rejected_code']);
                                                        // context.pushNamed(
                                                        //     kyc2Input,
                                                        //     extra: Kyc2Param(
                                                        //         isRejected:
                                                        //             true,
                                                        //         statusKyc1:
                                                        //             statusKyc1 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false,
                                                        //         statusKyc2:
                                                        //             statusKyc2 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false,
                                                        //         statusKyc3:
                                                        //             statusKyc3 ==
                                                        //                     '1'
                                                        //                 ? true
                                                        //                 : false));
                                                      },
                                                      child: SizedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              Languages.of(
                                                                      context)
                                                                  .reject,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Color(
                                                                    0xFFE02424),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                // GlobalFunction().rejectCodeKycDialog(
                                                                //     context,
                                                                //     subtitle: state
                                                                //             .data
                                                                //             .data
                                                                //             ?.kyc?['3']
                                                                //         [
                                                                //         'rejected_code']);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/ic_info_danger.png',
                                                                width: 17,
                                                                height: 17,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      statusKyc3.isEmpty
                                                          ? ''
                                                          : GlobalFunction()
                                                              .getStatusKyc(
                                                                  int.parse(
                                                                      statusKyc3),
                                                                  context),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                Languages.of(context)
                                                    .selfieVideo,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF7D8998),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              statusKyc1 == '2'
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        GlobalFunction()
                                                            .rejectCodeKycDialog(
                                                                context,
                                                                subtitle: state
                                                                        .data
                                                                        .data
                                                                        ?.kyc?['1']
                                                                    [
                                                                    'rejected_code']);
                                                        // context.pushNamed(
                                                        // kyc2Input,
                                                        // extra: Kyc2Param(
                                                        //     isRejected:
                                                        //         true,
                                                        //     statusKyc1:
                                                        //         statusKyc1 ==
                                                        //                 '1'
                                                        //             ? true
                                                        //             : false,
                                                        //     statusKyc2:
                                                        //         statusKyc2 ==
                                                        //                 '1'
                                                        //             ? true
                                                        //             : false,
                                                        //     statusKyc3:
                                                        //         statusKyc3 ==
                                                        //                 '1'
                                                        //             ? true
                                                        //             : false));
                                                      },
                                                      child: SizedBox(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              Languages.of(
                                                                      context)
                                                                  .reject,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: GoogleFonts
                                                                  .inter(
                                                                color: Color(
                                                                    0xFFE02424),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                height: 0,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5.0,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                // GlobalFunction().rejectCodeKycDialog(
                                                                //     context,
                                                                //     subtitle: state
                                                                //             .data
                                                                //             .data
                                                                //             ?.kyc?['1']
                                                                //         [
                                                                //         'rejected_code']);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/icons/ic_info_danger.png',
                                                                width: 17,
                                                                height: 17,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Text(
                                                      statusKyc1.isEmpty
                                                          ? ''
                                                          : GlobalFunction()
                                                              .getStatusKyc(
                                                                  int.parse(
                                                                      statusKyc1),
                                                                  context),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return MainButtonGradient(
                                          onTap: () {
                                            memberBloc.add(GetMemberEvent());
                                          },
                                          title:
                                              Languages.of(context).tryAgain);
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            width: double.infinity,
                            height: 80,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF252422),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/icons/ic_wa.png',
                                      scale: 3,
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Languages.of(context).customerService,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Alata',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Languages.of(context).needHelp,
                                          style: const TextStyle(
                                            color: Color(0xFF7D8998),
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                  width: Languages.of(context).callUs ==
                                          'Hubungi kami'
                                      ? 120
                                      : 100,
                                  child: Center(
                                    child: MainButtonGradient(
                                      height: 40,
                                      title: Languages.of(context).callUs,
                                      onTap: () {
                                        GlobalFunction().openUrl(url);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          MainButtonGradient(
                            onTap: () {
                              preferencesHelper.removeStringSharedPref('token');

                              preferencesHelper.removeStringSharedPref('id');
                              preferencesHelper.removeStringSharedPref('phone');
                              preferencesHelper
                                  .removeStringSharedPref('kyc_status');
                              preferencesHelper
                                  .removeStringSharedPref('kyc_status1');
                              preferencesHelper
                                  .removeStringSharedPref('kyc_status2');
                              preferencesHelper
                                  .removeStringSharedPref('kyc_status3');
                              context.pushReplacementNamed(login);
                            },
                            title: Languages.of(context).logOut,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
