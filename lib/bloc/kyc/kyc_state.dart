part of 'kyc_bloc.dart';

sealed class KycState extends Equatable {
  const KycState();

  @override
  List<Object> get props => [];
}

final class KycInitial extends KycState {}

final class PostKycLoading extends KycState {}

final class PostKycSuccess extends KycState {}

final class PostKycError extends KycState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostKycError({this.message, this.errors});
}

final class PostResubmitKycLoading extends KycState {}

final class PostResubmitKycSuccess extends KycState {}

final class PostResubmitKycError extends KycState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostResubmitKycError({this.message, this.errors});
}
