part of 'member_bloc.dart';

sealed class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class GetMemberEvent extends MemberEvent {}

class GetRelationshipEvent extends MemberEvent {}
