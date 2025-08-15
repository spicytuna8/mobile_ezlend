part of 'bank_bloc.dart';

sealed class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object> get props => [];
}

class GetBankInfoEvent extends BankEvent {
  const GetBankInfoEvent();
}
