import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_project/helper/router_name.dart';
import 'package:loan_project/model/kyc2_param.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/screen/home_screen.dart';
import 'package:loan_project/screen/loan/history_loan_detail_screen.dart';
import 'package:loan_project/screen/loan/kyc1_input_screen.dart';
import 'package:loan_project/screen/loan/kyc2_input_screen.dart';
import 'package:loan_project/screen/loan/loan_screen.dart';
import 'package:loan_project/screen/loan/sample_kyc_screen.dart';
import 'package:loan_project/screen/loan/sample_kyc_video_screen.dart';
import 'package:loan_project/screen/login_screen.dart';
import 'package:loan_project/screen/onboarding/onboarding1_screen.dart';
import 'package:loan_project/screen/onboarding/onboarding2_screen.dart';
import 'package:loan_project/screen/onboarding/onboarding3_screen.dart';
import 'package:loan_project/screen/onboarding/onboarding4_screen.dart';
import 'package:loan_project/screen/register_screen.dart';
import 'package:loan_project/screen/repayment/repayment_input_screen.dart';
import 'package:loan_project/screen/repayment/repayment_screen.dart';
import 'package:loan_project/screen/repayment/repayment_summary_screen.dart';
import 'package:loan_project/spalsh_screen.dart';
import 'package:loan_project/widget/bottom_navigation.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  routes: <RouteBase>[
    // GoRoute(
    //     path: '/',
    //     name: splash,
    //     builder: (context, state) => const SplashScreen()),
    // //     routes: [
    GoRoute(
        path: '/onboarding1',
        name: onboarding1,
        builder: (context, state) => const Onboarding1Screen(),
        routes: const []),
    GoRoute(
        path: '/onboarding2',
        name: onboarding2,
        builder: (context, state) => const Onboarding2Screen(),
        routes: const []),
    GoRoute(
        path: '/onboarding3',
        name: onboarding3,
        builder: (context, state) => const Onboarding3Screen(),
        routes: const []),
    GoRoute(
        path: '/onboarding4',
        name: onboarding4,
        builder: (context, state) => const Onboarding4Screen(),
        routes: const []),
    GoRoute(
      path: '/register',
      name: register,
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: '/login',
      name: login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/historyLoanDetail',
      name: historyLoanDetail,
      builder: (context, state) => HistoryLoanDetail(
        data: state.extra as DatumLoan,
      ),
    ),
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),

    GoRoute(
      path: '/bottomNavigation',
      name: bottomNavigation,
      builder: (context, state) => BottomNavigation(
        index: state.extra as int,
      ),
    ),

    GoRoute(
      path: '/home',
      name: home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/sampleKyc',
      name: sampleKyc,
      builder: (context, state) => const SampleKycScreen(),
    ),
    GoRoute(
      path: '/repaymentInput',
      name: repaymentInput,
      builder: (context, state) => RepaymentInputScreen(
        data: state.extra as RepaymentInputParam,
      ),
    ),
    GoRoute(
      path: '/sampleKycVideo',
      name: sampleKycVideo,
      builder: (context, state) => const SampleKycVideoScreen(),
    ),
    GoRoute(
        path: '/kyc1Input',
        name: kyc1Input,
        builder: (context, state) {
          return Kyc1InputScreen(
            nominal: state.extra as ItemPackageIndex,
          );
        }),
    GoRoute(
        path: '/kyc2Input',
        name: kyc2Input,
        builder: (context, state) {
          return Kyc2InputScreen(
            data: state.extra as Kyc2Param,
          );
        }),
    // GoRoute(
    //     path: '/sideMenu',
    //     name: sideMenu,
    //     builder: (context, state) {
    //       return const SideMenuScreen();
    //     }),
    GoRoute(
        path: '/loan',
        name: loan,
        builder: (context, state) {
          return const LoanScreen();
        }),
    GoRoute(
        path: '/repayment',
        name: repayment,
        builder: (context, state) {
          return const RepaymentScreen();
        }),
    GoRoute(
        path: '/repaymentSummary',
        name: repaymentSummary,
        builder: (context, state) {
          return RepaymentSummaryScreen(
            data: state.extra as RepaymentParam,
          );
        }),
  ],
);
