import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/bloc/service/service_bloc.dart';
import 'package:loan_project/model/response_get_member.dart';
import 'package:loan_project/model/response_get_service.dart';
import 'package:loan_project/model/response_relationship.dart';
import 'package:loan_project/service/api_service_member.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  ApiServiceMember apiServiceMember = ApiServiceMember();
  MemberBloc() : super(MemberInitial()) {
    on<GetMemberEvent>((event, emit) async {
      emit(GetMemberLoading());
      try {
        final response = await apiServiceMember.getMember();
        emit(GetMemberSuccess(ResponseGetMember.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetMemberError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetMemberError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<GetRelationshipEvent>((event, emit) async {
      emit(GetRelationshipLoading());
      try {
        final response = await apiServiceMember.getRelationship();
        emit(GetRelationshipSuccess(
            responseGetRelationshipFromJson(jsonEncode(response.data))));
      } on DioException catch (e) {
        emit(GetRelationshipError(
            message: e.response?.data['message'],
            errors: e.response?.data['errors']));
      } catch (e) {
        emit(GetRelationshipError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });

    // TODO: implement event handler
  }
}
