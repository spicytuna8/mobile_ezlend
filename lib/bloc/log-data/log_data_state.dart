part of 'log_data_bloc.dart';

sealed class LogDataState extends Equatable {
  const LogDataState();

  @override
  List<Object> get props => [];
}

final class LogDataInitial extends LogDataState {}

final class PostCreateLogDataSuccess extends LogDataState {
  final ResponseLogDataCreate data;

  PostCreateLogDataSuccess(this.data);
}

final class PostCreateLogDataLoading extends LogDataState {}

final class PostCreateLogDataError extends LogDataState {
  final String message;
  const PostCreateLogDataError(this.message);
}

final class PostLogFileLogDataSuccess extends LogDataState {}

final class PostLogFileLogDataLoading extends LogDataState {}

final class PostLogFileLogDataError extends LogDataState {
  final String message;
  const PostLogFileLogDataError(this.message);
}

final class PostActualNumberSuccess extends LogDataState {}

final class PostActualNumberLoading extends LogDataState {}

final class PostActualNumberError extends LogDataState {
  final String message;
  const PostActualNumberError(this.message);
}

final class PostCreateContactSuccess extends LogDataState {
  final ResponseContact data;
  PostCreateContactSuccess(this.data);
}

final class PostCreateContactLoading extends LogDataState {}

final class PostCreateContactError extends LogDataState {
  final String message;
  const PostCreateContactError(this.message);
}

final class PostCreateCallLogSuccess extends LogDataState {}

final class PostCreateCallLogLoading extends LogDataState {}

final class PostCreateCallLogError extends LogDataState {
  final String message;
  const PostCreateCallLogError(this.message);
}
