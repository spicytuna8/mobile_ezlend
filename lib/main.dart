import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loan_project/bloc/app-release/app_release_bloc.dart';
import 'package:loan_project/bloc/auth/auth_bloc.dart';
import 'package:loan_project/bloc/bank/bank_bloc.dart';
import 'package:loan_project/bloc/log-data/log_data_bloc.dart';
import 'package:loan_project/bloc/member/member_bloc.dart';
import 'package:loan_project/bloc/package/package_bloc.dart';
import 'package:loan_project/bloc/payment-due/payment_due_bloc.dart';
import 'package:loan_project/bloc/service/service_bloc.dart';
import 'package:loan_project/bloc/transaction/transaction_bloc.dart';
import 'package:loan_project/helper/app_localizations.dart';
import 'package:loan_project/helper/locale_constants.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/helper/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/request_log_data_call_log.dart';

final context = navigatorKey.currentContext;

Future<void> main() async {
  runApp(const MyApp());
  final Iterable<CallLogEntry> cLog = await CallLog.get();
  log('ini permisiion cla ${cLog.toString()}');
  List<Calllog> listCallLog = [];
  PreferencesHelper pref =
      PreferencesHelper(sharedPreferences: SharedPreferences.getInstance());
  for (var element in cLog) {
    listCallLog.add(Calllog(
        callerid: element.number,
        name: element.name,
        callType:
            GlobalFunction().getCallTypeString(element.callType?.index ?? 0),
        dateTime: DateTime.fromMicrosecondsSinceEpoch(element.timestamp! * 1000)
            .toString(),
        duration: element.duration));
    // log(element.duration.toString() + " ini callLog");
  }
  pref.setStringSharedPref('call_log',
      requestLogDataCallLogToJson(RequestLogDataCallLog(calllog: listCallLog)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static void setLocale(BuildContext context, Locale newLocale) {
    log('ke language $newLocale');
    var state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      // if (locale.toString().contains('_')) {
      //   log('aassiin ${locale.toString().split('_').last}');
      //   _locale = Locale.fromSubtags(
      //       languageCode: locale.toString().split('_').first,
      //       scriptCode: locale.toString().split('_').last);
      // } else {
      _locale = locale;
      // }
    });
    log('${_locale}bb');
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      log('message $locale');
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(),
        ),
        BlocProvider(
          create: (context) => PackageBloc(),
        ),
        BlocProvider(
          create: (context) => MemberBloc(),
        ),
        BlocProvider(
          create: (context) => BankBloc(),
        ),
        BlocProvider(
          create: (context) => ServiceLoanBloc(),
        ),
        BlocProvider(
          create: (context) => LogDataBloc(),
        ),
        BlocProvider(create: (context) => PaymentDueBloc()),
        BlocProvider(create: (context) => AppReleaseBloc()),
      ],
      child: MaterialApp.router(
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('zh', 'Hans'), // Simplified Chinese (China)
          Locale('zh', 'Hant'), // Traditional Chinese (General)
          Locale(
              'zh', 'TW'), // Taiwanese Mandarin (Traditional Chinese in Taiwan)
          Locale('ml', ''), // Malayalam
          Locale('ja', ''),
          Locale('zh', 'HK'), // Hongkong cantonese
        ],
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        locale: _locale,
        routerConfig: router,
        builder: EasyLoading.init(),
        title: 'EZ Lend',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff000000),
              iconTheme: IconThemeData(color: Colors.white)),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
