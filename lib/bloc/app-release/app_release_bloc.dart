import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_app_release.dart';
import 'package:loan_project/service/api_service_app_release.dart';

part 'app_release_event.dart';
part 'app_release_state.dart';

class AppReleaseBloc extends Bloc<AppReleaseEvent, AppReleaseState> {
  final ApiServiceAppRelease _apiServiceAppRelease = ApiServiceAppRelease();
  AppReleaseBloc() : super(AppReleaseInitial()) {
    on<GetLatest>((event, emit) async {
      emit(GetLatestLoading());
      try {
        final response = await _apiServiceAppRelease.postAppRelease(
            version: event.packageName);
        emit(GetLatestSuccess(ResponseAppRelease.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetLatestError(e.response?.data['message']));
      } catch (e) {
        emit(GetLatestError(e.toString()));
      }
    });
    on<PostCheckVersionEvent>((event, emit) async {
      emit(PostCheckVersionLoading());
      try {
        final response = await _apiServiceAppRelease.postCheckVersion(
            version: event.version);
        if (response.data['message'] == 'PLEASE_UPDATE_THE_APPS') {
          emit(PostCheckVersionError(response.data['message']));
        } else {
          emit(PostCheckVersionSuccess());
        }
      } on DioException catch (e) {
        emit(PostCheckVersionError(e.response?.data['message']));
      } catch (e) {
        emit(PostCheckVersionError(e.toString()));
      }
    });
  }
}
