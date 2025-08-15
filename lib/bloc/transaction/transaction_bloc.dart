import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/request_paid_with_file.dart';
import 'package:loan_project/model/response_bank_info.dart';
import 'package:loan_project/model/response_get_loan.dart';
import 'package:loan_project/model/response_check_loan.dart';
import 'package:loan_project/model/response_list_payment.dart';
import 'package:loan_project/model/response_paid.dart';
import 'package:loan_project/service/api_service_transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final ApiServiceTransaction _apiServiceTransaction = ApiServiceTransaction();
  TransactionBloc() : super(TransactionInitial()) {
    on<PostLoanEvent>((event, emit) async {
      emit(PostLoanLoading());
      try {
        final response = await _apiServiceTransaction.loan(
            packageId: event.packageId, dateLoan: event.dateLoan);
        emit(PostLoanSuccess());
      } on DioException catch (e) {
        emit(PostLoanError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(PostLoanError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<PostPaidEvent>((event, emit) async {
      emit(PostPaidLoading());
      try {
        final response = await _apiServiceTransaction.paid(
          loanpackageId: event.loanpackageId,
          amount: event.amount,
        );
        emit(PostPaidSuccess(data: ResponsePaid.fromJson(response.data)));
      } on DioException catch (e) {
        emit(PostPaidError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(PostPaidError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<CheckLoanEvent>((event, emit) async {
      emit(CheckLoanLoading());
      try {
        final response = await _apiServiceTransaction.checkLoan(
          packageId: event.packageId,
        );
        emit(CheckLoanSuccess(ResponseCheckLoan.fromJson(response.data)));
      } on DioException catch (e) {
        emit(CheckLoanError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(CheckLoanError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<GetLoanEvent>((event, emit) async {
      emit(GetLoanLoading());
      try {
        final response =
            await _apiServiceTransaction.getLoan(status: event.status);
        emit(GetLoanSuccess(ResponseGetLoan.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetLoanError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetLoanError(message: e.toString(), errors: const {}));
      }
    });

    on<PostPaidWithFileEvent>((event, emit) async {
      emit(PostPaidWithFileLoading());
      try {
        final response =
            await _apiServiceTransaction.paidWithFile(data: event.data);
        emit(PostPaidWithFileSuccess());
      } on DioException catch (e) {
        emit(PostPaidWithFileError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(PostPaidWithFileError(message: e.toString(), errors: const {}));
      }
    });
  }
}
