part of 'package_rate_bloc.dart';

sealed class PackageRateState extends Equatable {
  const PackageRateState();

  @override
  List<Object> get props => [];
}

final class PackageRateInitial extends PackageRateState {}

final class GetIndexPackageRateLoading extends PackageRateState {}

final class GetIndexPackageRateSuccess extends PackageRateState {
  final ResponsePackageRateIndex data;
  const GetIndexPackageRateSuccess(this.data);
}

final class GetIndexPackageRateError extends PackageRateState {}

final class GetViewPackageRateLoading extends PackageRateState {}

final class GetViewPackageRateSuccess extends PackageRateState {}

final class GetViewPackageRateError extends PackageRateState {}
