part of 'kyc_bloc.dart';

sealed class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object> get props => [];
}

class PostKycEvent extends KycEvent {
  final RequestKyc data;

  PostKycEvent({required this.data});
}

class PostResubmitKycEvent extends KycEvent {
  final RequestResubmitKyc data;

  PostResubmitKycEvent({required this.data});
}
