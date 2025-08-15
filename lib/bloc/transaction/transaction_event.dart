part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class PostLoanEvent extends TransactionEvent {
  final String packageId;
  final String dateLoan;
  const PostLoanEvent({
    required this.packageId,
    required this.dateLoan,
  });
}

class PostPaidEvent extends TransactionEvent {
  final String loanpackageId;
  final int amount;
  const PostPaidEvent({
    required this.loanpackageId,
    required this.amount,
  });
}

class PostPaidWOLoginEvent extends TransactionEvent {
  final String ic;
  final int amount;
  const PostPaidWOLoginEvent({
    required this.ic,
    required this.amount,
  });
}

class PostPaidWithFileEvent extends TransactionEvent {
  final RequestPaidWithFile data;
  const PostPaidWithFileEvent({
    required this.data,
  });
}

class CheckLoanEvent extends TransactionEvent {
  final String packageId;
  const CheckLoanEvent({
    required this.packageId,
  });
}

class GetLoanEvent extends TransactionEvent {
  final int? status;
  const GetLoanEvent({this.status});
}




// class GetBankInfoEvent extends TransactionEvent {
//   const GetBankInfoEvent();
// }
