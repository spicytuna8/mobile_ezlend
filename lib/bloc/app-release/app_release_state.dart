part of 'app_release_bloc.dart';

sealed class AppReleaseState extends Equatable {
  const AppReleaseState();

  @override
  List<Object> get props => [];
}

final class AppReleaseInitial extends AppReleaseState {}

class GetLatestLoading extends AppReleaseState {}

class GetLatestSuccess extends AppReleaseState {
  final ResponseAppRelease data;

  const GetLatestSuccess(this.data);
}

class GetLatestError extends AppReleaseState {
  final String error;
  const GetLatestError(this.error);
}

class PostCheckVersionLoading extends AppReleaseState {}

class PostCheckVersionSuccess extends AppReleaseState {}

class PostCheckVersionError extends AppReleaseState {
  final String error;
  const PostCheckVersionError(this.error);
}
