import 'package:loan_project/model/response_package_index.dart';

class Kyc2Param {
  final ItemPackageIndex? itemPackage;
  final String? namePerId;
  final String? idNumber;
  final String? benefiaryName;
  final String? benefiaryContact;
  final String? beneficiaryRelationship;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;
  final bool isRejected;
  final bool? statusKyc1;
  final bool? statusKyc2;
  final bool? statusKyc3;

  Kyc2Param(
      {this.itemPackage,
      this.namePerId,
      this.idNumber,
      this.benefiaryName,
      this.benefiaryContact,
      this.beneficiaryRelationship,
      this.bankName,
      this.accountName,
      this.accountNumber,
      this.statusKyc1,
      this.statusKyc2,
      this.statusKyc3,
      this.isRejected = false});
}
