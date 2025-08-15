import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_package_rate.dart';
import 'package:loan_project/service/api_service_package_rate.dart';

part 'package_rate_event.dart';
part 'package_rate_state.dart';

class PackageRateBloc extends Bloc<PackageRateEvent, PackageRateState> {
  final ApiServicePackageRate _apiServicePackage = ApiServicePackageRate();
  PackageRateBloc() : super(PackageRateInitial()) {
    on<GetIndexPackageRateEvent>((event, emit) async {
      emit(GetIndexPackageRateLoading());
      try {
        final response = await _apiServicePackage.index(
            page: event.page, perPage: event.perPage);
        emit(GetIndexPackageRateSuccess(
            ResponsePackageRateIndex.fromJson(response.data)));
      } on DioException {
        emit(GetIndexPackageRateError());
      } catch (e) {
        emit(GetIndexPackageRateError());
      }
      // TODO: implement event handler
    });
    on<GetViewPackageRateEvent>((event, emit) async {
      emit(GetViewPackageRateLoading());
      try {
        final response = await _apiServicePackage.view(
          id: event.id,
        );
        emit(GetViewPackageRateSuccess());
      } on DioException {
        emit(GetViewPackageRateError());
      } catch (e) {
        emit(GetViewPackageRateError());
      }
      // TODO: implement event handler
    });
  }
}
