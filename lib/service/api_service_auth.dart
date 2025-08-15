import 'package:dio/dio.dart';
import 'package:loan_project/helper/api_logger.dart';
import 'package:loan_project/helper/network_helper.dart';

class ApiServiceAuth {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> login({required String ic, required String phone}) async {
    // Log untuk debugging login attempt
    ApiLogger.logMessage('Attempting login for IC: $ic', tag: 'AUTH');

    final response = await _dio.post('v1/member/auth/login', data: {'ic': ic, 'phone': phone});
    return response;
  }

  Future<Response> register({
    required String ic,
    required String phone,
    // required String email
  }) async {
    // Log untuk debugging register attempt
    ApiLogger.logMessage('Attempting registration for IC: $ic', tag: 'AUTH');

    final response = await _dio.post('v1/member/auth/register', data: {
      'ic': ic,
      'phone': phone,
      // 'email': email,
    });
    return response;
  }

  Future<Response> getEmailVerification({required String verificationToken}) async {
    final response = await _dio.get('v1/member/auth/mail-confirmation', params: {
      'verification-token': verificationToken,
    });
    return response;
  }
}
