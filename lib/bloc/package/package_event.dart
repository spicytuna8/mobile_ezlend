part of 'package_bloc.dart';

sealed class PackageEvent extends Equatable {
  const PackageEvent();

  @override
  List<Object> get props => [];
}

class GetIndexPackageEvent extends PackageEvent {
  final int page;
  final int perPage;
  const GetIndexPackageEvent({required this.page, required this.perPage});
}

class GetViewPackageEvent extends PackageEvent {
  final int id;
  const GetViewPackageEvent({
    required this.id,
  });
}
