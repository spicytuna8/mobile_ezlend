part of 'member_bloc.dart';

sealed class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

final class MemberInitial extends MemberState {}

final class GetMemberLoading extends MemberState {}

final class GetMemberSuccess extends MemberState {
  final ResponseGetMember data;

  GetMemberSuccess(this.data);
}

final class GetMemberError extends MemberState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetMemberError({this.message, this.errors});
}

final class GetRelationshipLoading extends MemberState {}

final class GetRelationshipSuccess extends MemberState {
  final List<ResponseGetRelationship> data;

  GetRelationshipSuccess(this.data);
}

final class GetRelationshipError extends MemberState {
  final String? message;
  final Map<String, dynamic>? errors;
  const GetRelationshipError({this.message, this.errors});
}
