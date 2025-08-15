import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_package_index.dart';
import 'package:loan_project/service/api_service_package.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final ApiServicePackage _apiServicePackage = ApiServicePackage();
  PackageBloc() : super(PackageInitial()) {
    on<GetIndexPackageEvent>((event, emit) async {
      emit(GetIndexPackageLoading());
      try {
        final response = await _apiServicePackage.index(
            page: event.page, perPage: event.perPage);
        emit(GetIndexPackageSuccess(
            ResponsePackageIndex.fromJson(response.data)));
      } on DioException catch (e) {
        emit(GetIndexPackageError(e.response?.data['data']));
      } catch (e) {
        emit(GetIndexPackageError(e.toString()));
      }
      // TODO: implement event handler
    });
    on<GetViewPackageEvent>((event, emit) async {
      emit(GetViewPackageLoading());
      try {
        final response = await _apiServicePackage.view(
          id: event.id,
        );
        emit(GetViewPackageSuccess());
      } on DioException {
        emit(GetViewPackageError());
      } catch (e) {
        emit(GetViewPackageError());
      }
      // TODO: implement event handler
    });
  }
}
