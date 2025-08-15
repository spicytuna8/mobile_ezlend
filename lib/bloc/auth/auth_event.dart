part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class PostLoginEvent extends AuthEvent {
  final String ic;
  final String phone;
  const PostLoginEvent({required this.ic, required this.phone});
}

class PostRegisterEvent extends AuthEvent {
  final String ic;
  final String phone;
  // final String email;
  const PostRegisterEvent({
    required this.ic,
    required this.phone,
    // required this.email
  });
}

class GetEmailVerificationEvent extends AuthEvent {
  final String emailVerification;
  const GetEmailVerificationEvent({required this.emailVerification});
}
