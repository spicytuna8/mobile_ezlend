part of 'package_bloc.dart';

sealed class PackageState extends Equatable {
  const PackageState();

  @override
  List<Object> get props => [];
}

final class PackageInitial extends PackageState {}

final class GetIndexPackageLoading extends PackageState {}

final class GetIndexPackageSuccess extends PackageState {
  final ResponsePackageIndex data;
  const GetIndexPackageSuccess(this.data);
}

final class GetIndexPackageError extends PackageState {
  final String message;

  GetIndexPackageError(this.message);
}

final class GetViewPackageLoading extends PackageState {}

final class GetViewPackageSuccess extends PackageState {}

final class GetViewPackageError extends PackageState {}
