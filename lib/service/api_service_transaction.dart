import 'package:dio/dio.dart';
import 'package:loan_project/helper/network_helper.dart';
import 'package:loan_project/model/request_paid_with_file.dart';

class ApiServiceTransaction {
  final NetworkHelper _dio = NetworkHelper();

  Future<Response> loan({
    required String packageId,
    required String dateLoan,
  }) async {
    final response = await _dio.post('v1/member/loan/calculate-loan', data: {
      'packageId': packageId,
      'dateloan': dateLoan,
      // 'remark': remark,
    });
    return response;
  }

  Future<Response> checkLoan({
    required String packageId,
  }) async {
    final response = await _dio.get('v1/member/loan/cek-loan', params: {
      'packageId': packageId,
    });
    return response;
  }

  Future<Response> paidWOLogin(
      {required String ic, required int amount}) async {
    final response = await _dio.post('v1/member/loan/paid-loan-without-login',
        data: {'ic': ic, 'amount': amount});
    return response;
  }

  Future<Response> paid(
      {required String loanpackageId, required int amount}) async {
    final response = await _dio.post('v1/member/loan/paid-loan',
        data: {'loanpackageId': loanpackageId, 'amount': amount});
    return response;
  }

  Future<Response> paidWithFile({required RequestPaidWithFile data}) async {
    final response = await _dio.post('v1/member/topup', data: data.toJson());
    return response;
  }

  Future<Response> getLoan({int? status}) async {
    final response = await _dio
        .get('v1/member/loan/loan-package', params: {"statusloan": status});
    return response;
  }

  Future<Response> getBankInfo({int? status}) async {
    final response = await _dio.get('v1/member/reference/payment-account');
    return response;
  }

  Future<Response> getListPayment(String loanpackageid) async {
    final response = await _dio.get('v1/member/topup/gettopup',
        params: {'loanpackageid': loanpackageid});
    return response;
  }

  Future<Response> checkDueDate({String? ic}) async {
    final response =
        await _dio.get('v1/member/loan/cek-due-date', params: {'ic': ic});
    return response;
  }
}
