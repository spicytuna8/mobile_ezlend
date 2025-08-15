part of 'package_rate_bloc.dart';

sealed class PackageRateEvent extends Equatable {
  const PackageRateEvent();

  @override
  List<Object> get props => [];
}

class GetIndexPackageRateEvent extends PackageRateEvent {
  final int page;
  final int perPage;
  const GetIndexPackageRateEvent({required this.page, required this.perPage});
}

class GetViewPackageRateEvent extends PackageRateEvent {
  final int id;
  const GetViewPackageRateEvent({
    required this.id,
  });
}
