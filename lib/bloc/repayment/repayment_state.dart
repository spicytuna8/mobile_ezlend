part of 'repayment_bloc.dart';

sealed class RepaymentState extends Equatable {
  const RepaymentState();

  @override
  List<Object> get props => [];
}

final class RepaymentInitial extends RepaymentState {}

final class GetListPaymentLoading extends RepaymentState {}

final class GetListPaymentSuccess extends RepaymentState {
  final ResponseGetListPayment data;

  GetListPaymentSuccess(this.data);
}

final class GetListPaymentError extends RepaymentState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetListPaymentError({this.message, this.errors});
}
