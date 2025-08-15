part of 'app_release_bloc.dart';

sealed class AppReleaseEvent extends Equatable {
  const AppReleaseEvent();

  @override
  List<Object> get props => [];
}

class GetLatest extends AppReleaseEvent {
  final String packageName;

  const GetLatest({required this.packageName});
}

class PostCheckVersionEvent extends AppReleaseEvent {
  final String version;

  const PostCheckVersionEvent({required this.version});
}
