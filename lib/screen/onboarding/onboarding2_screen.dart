// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/widget/main_button_gradient.dart';
import 'package:loan_project/widget/rounded_container.dart';

class Onboarding2Screen extends StatefulWidget {
  const Onboarding2Screen({Key? key}) : super(key: key);

  @override
  State<Onboarding2Screen> createState() => _Onboarding2ScreenState();
}

class _Onboarding2ScreenState extends State<Onboarding2Screen> {
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
                    image: AssetImage('assets/images/bg_onboarding2.png'),
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
                          Languages.of(context).transparency,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        '2 of 4',
                        style: TextStyle(
                          color: Color(0xFF7D8998),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Text(
                    Languages.of(context).understandLoanTerms,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
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
                            context.pushNamed(onboarding3);
                          },
                          title: Languages.of(context).continueText))
                ],
              ),
            ),
          ),
        ));
  }
}
