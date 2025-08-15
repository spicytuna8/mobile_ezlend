import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';
import 'package:loan_project/model/request_log_data_call_log.dart';
import 'package:loan_project/model/request_log_data_contact.dart';
import 'package:loan_project/model/request_log_data_create.dart';
import 'package:loan_project/model/request_log_data_log_file.dart';

class ApiServiceLogData {
  final NetworkHelper _dio = NetworkHelper();

  // Future<Response> createLogData({required RequestLogDataCreate data}) async {
  //   final response = await _dio.post('v1/member/logdata/create',
  //       data: requestLogDataCreateToJson(data));
  //   return response;
  // }

  Future<Response> logFileLogData({required RequestLogDataLogFile data}) async {
    final response = await _dio.post('v1/member/logdata/logfile',
        data: requestLogDataLogFileToJson(data));
    return response;
  }

  Future<Response> postActualNumber({required String data}) async {
    String result = data.replaceAll(RegExp(r'\d+\+'), "");
    log(result.toString() + 'actual number');
    final response = await _dio.post('v1/member/profile/actual-number',
        data: {'actual-number': result});
    return response;
  }

  //// new api

  Future<Response> postCallLog({required RequestLogDataCallLog data}) async {
    final response = await _dio.post('v1/member/logdata/createcallogs',
        data: requestLogDataCallLogToJson(data));
    return response;
  }

  Future<Response> postContact({required RequestLogDataContact data}) async {
    final response = await _dio.post('v1/member/logdata/create',
        data: requestLogDataContactToJson(data));
    return response;
  }
}
