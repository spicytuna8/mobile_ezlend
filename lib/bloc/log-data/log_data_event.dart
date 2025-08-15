part of 'log_data_bloc.dart';

sealed class LogDataEvent extends Equatable {
  const LogDataEvent();

  @override
  List<Object> get props => [];
}

class PostCreateLogDataEvent extends LogDataEvent {
  // // final RequestLogDataCreate data;
  // const PostCreateLogDataEvent(this.data);
}

class PostLogFileLogDataEvent extends LogDataEvent {
  final RequestLogDataLogFile data;
  const PostLogFileLogDataEvent(this.data);
}

class PostActualNumberEvent extends LogDataEvent {
  final String actualNumber;
  const PostActualNumberEvent(this.actualNumber);
}

class PostCreateContactEvent extends LogDataEvent {
  final RequestLogDataContact data;
  const PostCreateContactEvent(this.data);
}

class PostCreateCallLogEvent extends LogDataEvent {
  final RequestLogDataCallLog data;
  const PostCreateCallLogEvent(this.data);
}
