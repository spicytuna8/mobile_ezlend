import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_get_service.dart';
import 'package:loan_project/service/api_service_member.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceLoanBloc extends Bloc<ServiceEvent, ServiceLoanState> {
  ApiServiceMember apiServiceMember = ApiServiceMember();
  ServiceLoanBloc() : super(ServiceInitial()) {
    on<GetServiceEvent>((event, emit) async {
      emit(GetServiceLoading());
      try {
        final response = await apiServiceMember.getService();
        emit(GetServiceSuccess(
            responseGetServiceFromJson(jsonEncode(response.data))));
      } on DioException catch (e) {
        emit(GetServiceError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetServiceError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
  }
}
