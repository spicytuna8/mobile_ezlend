part of 'repayment_bloc.dart';

sealed class RepaymentEvent extends Equatable {
  const RepaymentEvent();

  @override
  List<Object> get props => [];
}

class GetListPaymentEvent extends RepaymentEvent {
  final String loanpackageid;
  const GetListPaymentEvent({required this.loanpackageid});
}
