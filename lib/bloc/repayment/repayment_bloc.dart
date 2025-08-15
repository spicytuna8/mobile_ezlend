import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_list_payment.dart';
import 'package:loan_project/service/api_service_transaction.dart';

part 'repayment_event.dart';
part 'repayment_state.dart';

class RepaymentBloc extends Bloc<RepaymentEvent, RepaymentState> {
  final ApiServiceTransaction _apiServiceTransaction = ApiServiceTransaction();

  RepaymentBloc() : super(RepaymentInitial()) {
    on<GetListPaymentEvent>((event, emit) async {
      emit(GetListPaymentLoading());
      try {
        final response =
            await _apiServiceTransaction.getListPayment(event.loanpackageid);
        emit(GetListPaymentSuccess(
            ResponseGetListPayment.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetListPaymentError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetListPaymentError(message: e.toString(), errors: const {}));
      }
    });
  }
}
