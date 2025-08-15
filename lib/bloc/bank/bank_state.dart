part of 'bank_bloc.dart';

sealed class BankState extends Equatable {
  const BankState();

  @override
  List<Object> get props => [];
}

final class BankInitial extends BankState {}

final class GetBankInfoLoading extends BankState {}

final class GetBankInfoSuccess extends BankState {
  final ResponseBankInfo data;

  GetBankInfoSuccess(this.data);
}

final class GetBankInfoError extends BankState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetBankInfoError({this.message, this.errors});
}
