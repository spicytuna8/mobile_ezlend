part of 'transaction_bloc.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

final class TransactionInitial extends TransactionState {}

final class PostLoanLoading extends TransactionState {}

final class PostLoanSuccess extends TransactionState {}

final class PostLoanError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostLoanError({this.message, this.errors});
}

final class PostPaidLoading extends TransactionState {}

final class PostPaidSuccess extends TransactionState {
  final ResponsePaid? data;

  PostPaidSuccess({this.data});
}

final class PostPaidError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostPaidError({this.message, this.errors});
}

final class CheckLoanLoading extends TransactionState {}

final class CheckLoanSuccess extends TransactionState {
  final ResponseCheckLoan data;
  const CheckLoanSuccess(this.data);
}

final class CheckLoanError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const CheckLoanError({this.message, this.errors});
}

final class GetLoanLoading extends TransactionState {}

final class GetLoanSuccess extends TransactionState {
  final ResponseGetLoan data;

  GetLoanSuccess(this.data);
}

final class GetLoanError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetLoanError({this.message, this.errors});
}

final class PostPaidWithFileLoading extends TransactionState {}

final class PostPaidWithFileSuccess extends TransactionState {
  // final ResponsePostPaidWithFile data;

  PostPaidWithFileSuccess(
      // this.data
      );
}

final class PostPaidWithFileError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostPaidWithFileError({this.message, this.errors});
}

final class PostPaidWOLoginLoading extends TransactionState {}

final class PostPaidWOLoginSuccess extends TransactionState {}

final class PostPaidWOLoginError extends TransactionState {
  final String? message;
  final Map<String, dynamic>? errors;
  const PostPaidWOLoginError({this.message, this.errors});
}
