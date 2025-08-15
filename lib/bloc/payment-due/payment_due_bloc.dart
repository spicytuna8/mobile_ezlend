import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_cek_due_date.dart';
import 'package:loan_project/service/api_service_transaction.dart';

part 'payment_due_event.dart';
part 'payment_due_state.dart';

class PaymentDueBloc extends Bloc<PaymentDueEvent, PaymentDueState> {
  final ApiServiceTransaction _apiServiceTransaction = ApiServiceTransaction();

  PaymentDueBloc() : super(PaymentDueInitial()) {
    on<CheckDueDateEvent>((event, emit) async {
      emit(CheckDueDateLoading());
      try {
        final response =
            await _apiServiceTransaction.checkDueDate(ic: event.ic);
        emit(CheckDueDateSuccess(ResponseCekDueDate.fromJson(response.data)));
      } on DioException catch (e) {
        emit(CheckDueDateError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(CheckDueDateError(message: e.toString(), errors: const {}));
      }
    });
  }
}
