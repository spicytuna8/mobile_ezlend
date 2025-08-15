import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_bank_info.dart';
import 'package:loan_project/service/api_service_transaction.dart';

part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final ApiServiceTransaction _apiServiceTransaction = ApiServiceTransaction();

  BankBloc() : super(BankInitial()) {
    on<GetBankInfoEvent>((event, emit) async {
      emit(GetBankInfoLoading());
      try {
        final response = await _apiServiceTransaction.getBankInfo();
        emit(GetBankInfoSuccess(ResponseBankInfo.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetBankInfoError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetBankInfoError(message: e.toString(), errors: const {}));
      }
    });
  }
}
