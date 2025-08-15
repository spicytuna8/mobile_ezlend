import 'dart:developer';

import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:loan_project/flavor.dart';
import 'package:loan_project/helper/preference_helper.dart';
import 'package:loan_project/main.dart';
import 'package:loan_project/model/request_log_data_call_log.dart';
import 'package:loan_project/widget/global_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // setPathUrlStrategy();

  F.appFlavor = Flavor.DEV;

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
