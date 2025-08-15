part of 'service_bloc.dart';

sealed class ServiceLoanState extends Equatable {
  const ServiceLoanState();

  @override
  List<Object> get props => [];
}

final class ServiceInitial extends ServiceLoanState {}

final class GetServiceLoading extends ServiceLoanState {}

final class GetServiceSuccess extends ServiceLoanState {
  final ResponseGetService data;

  GetServiceSuccess(this.data);
}

final class GetServiceError extends ServiceLoanState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetServiceError({this.message, this.errors});
}
