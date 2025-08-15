import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/helper/text_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PreferencesHelper preferencesHelper =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  // AppReleaseBloc _appReleaseBloc = AppReleaseBloc();
  // PackageInfo? _packageInfo;

  // Future<void> getLatest() async {
  //   _packageInfo = await PackageInfo.fromPlatform();

  //   if (!kIsWeb) {
  //     _appReleaseBloc.add(GetLatest(packageName: _packageInfo!.packageName));
  //   }
  // }

  _navigateToAfterSplash() async {
    String token = '';
    token = await preferencesHelper.getToken;
    // getLatest();
    log(token);
    bool onboardingPass =
        await preferencesHelper.isSharedPref('onboarding_pass');
    Timer(const Duration(seconds: 1), () {
      if (token == '') {
        if (onboardingPass) {
          context.pushNamed(login);
        } else {
          context.pushNamed(onboarding1);
        }
        // context.pushNamed(login);
      } else {
        context.pushNamed(bottomNavigation, extra: 0);
      }
    });
  }

  @override
  void initState() {
    _navigateToAfterSplash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: baseColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  'EZ',
                  style: white64w600,
                )
              ],
            ),
          ),
        ),
      ),
      //   ),
    );
  }
}
