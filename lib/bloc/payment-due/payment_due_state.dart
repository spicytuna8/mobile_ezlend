part of 'payment_due_bloc.dart';

sealed class PaymentDueState extends Equatable {
  const PaymentDueState();

  @override
  List<Object> get props => [];
}

final class PaymentDueInitial extends PaymentDueState {}

final class CheckDueDateLoading extends PaymentDueState {}

final class CheckDueDateSuccess extends PaymentDueState {
  final ResponseCekDueDate data;

  CheckDueDateSuccess(this.data);
}

final class CheckDueDateError extends PaymentDueState {
  final String? message;
  final Map<String, dynamic>? errors;
  const CheckDueDateError({this.message, this.errors});
}
