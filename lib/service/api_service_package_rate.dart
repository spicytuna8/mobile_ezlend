import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';

class ApiServicePackageRate {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> index({required int page, required int perPage}) async {
    final response = await _dio.get('v1/member/package-rate', params: {
      'page': page,
      'perPage': perPage,
    });
    return response;
  }

  Future<Response> view({
    required int id,
  }) async {
    final response = await _dio.post('v1/member/package-rate/view', params: {
      'id': id,
    });
    return response;
  }
}
