// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/rounded_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding4Screen extends StatefulWidget {
  const Onboarding4Screen({Key? key}) : super(key: key);

  @override
  State<Onboarding4Screen> createState() => _Onboarding4ScreenState();
}

class _Onboarding4ScreenState extends State<Onboarding4Screen> {
  final PreferencesHelper _preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_onboarding4.png'),
                    fit: BoxFit.cover)),
            child: const Column(
              children: [],
            ),
          ),
        ),
        bottomSheet: ClipPath(
          clipper: RoundedDiagonalClipper(),
          child: Container(
            padding: const EdgeInsets.all(16),
            height: 250,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0)),
              color: Color(0xff252422),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [
                              Color(0xFFFED607),
                              Color(0xFFF77F00),
                              Color.fromARGB(255, 214, 111, 0)
                            ],
                          ).createShader(bounds);
                        },
                        child: Text(
                          Languages.of(context).safeAndSecure,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '4 of 4',
                        style: GoogleFonts.inter(
                          color: Color(0xFF7D8998),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    Languages.of(context).trustInSafeAndReliableApplication,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: MainButtonGradient(
                        onTap: () {
                          _preferencesHelper.setSharedPref(
                              'onboarding_pass', true);
                          context.pushNamed(login);
                        },
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
