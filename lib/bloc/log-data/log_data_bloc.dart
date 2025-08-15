import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/request_log_data_call_log.dart';
import 'package:loan_project/model/request_log_data_contact.dart';
import 'package:loan_project/model/request_log_data_log_file.dart';
import 'package:loan_project/model/response_contact.dart';
import 'package:loan_project/model/response_log_data_create.dart';
import 'package:loan_project/service/api_service_log_data.dart';

part 'log_data_event.dart';
part 'log_data_state.dart';

class LogDataBloc extends Bloc<LogDataEvent, LogDataState> {
  final ApiServiceLogData _apiServiceLogData = ApiServiceLogData();
  LogDataBloc() : super(LogDataInitial()) {
    // on<PostCreateLogDataEvent>((event, emit) async {
    //   emit(PostCreateLogDataLoading());
    //   try {
    //     final response =
    //         await _apiServiceLogData.createLogData(data: event.data);
    //     emit(PostCreateLogDataSuccess(
    //         ResponseLogDataCreate.fromJson(response.data)));
    //   } on DioException catch (e) {
    //     emit(PostCreateLogDataError(e.response?.data['message']));
    //   } catch (e) {
    //     emit(PostCreateLogDataError(e.toString()));
    //   }
    //   // TODO: implement event handler
    // });
    on<PostLogFileLogDataEvent>((event, emit) async {
      emit(PostLogFileLogDataLoading());
      try {
        final response =
            await _apiServiceLogData.logFileLogData(data: event.data);
        emit(PostLogFileLogDataSuccess());
      } on DioException catch (e) {
        emit(PostLogFileLogDataError(e.response?.data['message']));
      } catch (e) {
        emit(PostLogFileLogDataError(e.toString()));
      }
      // TODO: implement event handler
    });
    on<PostActualNumberEvent>((event, emit) async {
      emit(PostActualNumberLoading());
      try {
        final response =
            await _apiServiceLogData.postActualNumber(data: event.actualNumber);
        emit(PostActualNumberSuccess());
      } on DioException catch (e) {
        emit(PostActualNumberError(e.response?.data['message']));
      } catch (e) {
        emit(PostActualNumberError(e.toString()));
      }
      // TODO: implement event handler
    });
    on<PostCreateContactEvent>((event, emit) async {
      emit(PostCreateContactLoading());
      try {
        final response = await _apiServiceLogData.postContact(data: event.data);
        emit(PostCreateContactSuccess(ResponseContact.fromJson(response.data)));
      } on DioException catch (e) {
        emit(PostCreateContactError(e.response?.data['message']));
      } catch (e) {
        emit(PostCreateContactError(e.toString()));
      }
      // TODO: implement event handler
    });
    on<PostCreateCallLogEvent>((event, emit) async {
      emit(PostCreateCallLogLoading());
      try {
        final response = await _apiServiceLogData.postCallLog(data: event.data);
        emit(PostCreateCallLogSuccess());
      } on DioException catch (e) {
        emit(PostCreateCallLogError(e.response?.data['message']));
      } catch (e) {
        emit(PostCreateCallLogError(e.toString()));
      }
      // TODO: implement event handler
    });
  }
}
