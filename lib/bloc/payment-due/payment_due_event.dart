part of 'payment_due_bloc.dart';

sealed class PaymentDueEvent extends Equatable {
  const PaymentDueEvent();

  @override
  List<Object> get props => [];
}

class CheckDueDateEvent extends PaymentDueEvent {
  final String? ic;
  const CheckDueDateEvent({this.ic});
}
