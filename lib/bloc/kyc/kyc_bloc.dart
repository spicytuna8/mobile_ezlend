import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/request_kyc.dart';
import 'package:loan_project/model/request_resubmit_kyc.dart';
import 'package:loan_project/service/api_service_kyc.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  ApiServiceKyc apiServiceKyc = ApiServiceKyc();
  KycBloc() : super(KycInitial()) {
    on<PostKycEvent>((event, emit) async {
      emit(PostKycLoading());
      try {
        final response = await apiServiceKyc.postKyc(data: event.data);
        emit(PostKycSuccess());
      } on DioException catch (e) {
        emit(PostKycError(
            message: e.response?.data['message'],
            errors: e.response?.data['data']));
      } catch (e) {
        emit(PostKycError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<PostResubmitKycEvent>((event, emit) async {
      emit(PostResubmitKycLoading());
      try {
        final response = await apiServiceKyc.postResubmitKyc(data: event.data);
        emit(PostResubmitKycSuccess());
      } on DioException catch (e) {
        emit(PostResubmitKycError(
            message: e.response?.data['message'],
            errors: e.response?.data['data']));
      } catch (e) {
        emit(PostResubmitKycError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
  }
}
