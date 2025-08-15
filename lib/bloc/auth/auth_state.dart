part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class PostLoginLoading extends AuthState {}

final class PostLoginSuccess extends AuthState {
  final ResponseLogin data;
  const PostLoginSuccess(this.data);
}

final class PostLoginError extends AuthState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostLoginError({this.message, this.errors});
}

final class PostRegisterLoading extends AuthState {}

final class PostRegisterSuccess extends AuthState {
  final ResponseRegister data;
  const PostRegisterSuccess(this.data);
}

final class PostRegisterError extends AuthState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostRegisterError({this.message, this.errors});
}

final class GetEmailVerificationLoading extends AuthState {}

final class GetEmailVerificationSuccess extends AuthState {}

final class GetEmailVerificationError extends AuthState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetEmailVerificationError({this.message, this.errors});
}
