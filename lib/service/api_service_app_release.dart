import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';

class ApiServiceAppRelease {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> postAppRelease({
    required String version,
  }) async {
    final response = await _dio
        .post('v1/member/profile/app-release', data: {'version': version});
    return response;
  }

  Future<Response> postCheckVersion({
    required String version,
  }) async {
    final response = await _dio.post('v1/member/reference/version',
        data: {'version': version, 'platform': 'android'});
    return response;
  }
}
