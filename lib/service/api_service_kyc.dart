import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';
import 'package:loan_project/model/request_kyc.dart';
import 'package:loan_project/model/request_resubmit_kyc.dart';

class ApiServiceKyc {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> postKyc({
    required RequestKyc data,
  }) async {
    final response =
        await _dio.post('v1/member/profile/kycnew', data: data.toJson());
    return response;
  }

  Future<Response> postResubmitKyc({
    required RequestResubmitKyc data,
  }) async {
    log(data.toJson().toString() + "dataaa");
    final response =
        await _dio.post('v1/member/profile/kycnew', data: data.toJson());
    return response;
  }
}
