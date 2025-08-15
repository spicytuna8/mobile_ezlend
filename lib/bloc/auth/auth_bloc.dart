import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_project/model/response_login.dart';
import 'package:loan_project/model/response_register.dart';
import 'package:loan_project/service/api_service_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiServiceAuth _apiServiceAuth = ApiServiceAuth();
  AuthBloc() : super(AuthInitial()) {
    on<PostLoginEvent>((event, emit) async {
      emit(PostLoginLoading());
      try {
        final response =
            await _apiServiceAuth.login(ic: event.ic, phone: event.phone);
        emit(PostLoginSuccess(ResponseLogin.fromJson(response.data)));
      } on DioException catch (e) {
        emit(PostLoginError(
            message: e.response?.data['message'],
            errors: e.response?.data['data']));
      } catch (e) {
        emit(PostLoginError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<PostRegisterEvent>((event, emit) async {
      emit(PostRegisterLoading());
      try {
        final response =
            await _apiServiceAuth.register(ic: event.ic, phone: event.phone);
        emit(PostRegisterSuccess(ResponseRegister.fromJson(response.data)));
      } on DioException catch (e) {
        emit(PostRegisterError(
            message: e.response?.data['message'],
            errors: e.response?.data['data']));
      } catch (e) {
        emit(PostRegisterError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
    on<GetEmailVerificationEvent>((event, emit) async {
      emit(GetEmailVerificationLoading());
      try {
        final response = await _apiServiceAuth.getEmailVerification(
          verificationToken: event.emailVerification,
        );
        emit(GetEmailVerificationSuccess());
      } on DioException catch (e) {
        emit(GetEmailVerificationError(
            message: e.response?.data['message'],
            errors: e.response?.data['data']));
      } catch (e) {
        emit(
            GetEmailVerificationError(message: e.toString(), errors: const {}));
      }
      // TODO: implement event handler
    });
  }
}
