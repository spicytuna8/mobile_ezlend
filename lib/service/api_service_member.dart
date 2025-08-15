import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';
import 'package:loan_project/model/request_kyc.dart';

class ApiServiceMember {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> getMember() async {
    final response = await _dio.get('v1/member/profile/member-kyc');
    return response;
  }

  Future<Response> getRelationship() async {
    final response = await _dio.get('v1/member/relationship');
    return response;
  }

  Future<Response> getService() async {
    final response = await _dio.get('v1/member/service');
    return response;
  }
}
