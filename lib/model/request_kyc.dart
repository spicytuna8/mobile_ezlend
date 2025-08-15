// To parse this JSON data, do
//
//     final requestKyc = requestKycFromJson(jsonString);

import 'dart:convert';

RequestKyc requestKycFromJson(String str) =>
    RequestKyc.fromJson(json.decode(str));

String requestKycToJson(RequestKyc data) => json.encode(data.toJson());

class RequestKyc {
  Member? member;
  List<KycFile>? kycFile;

  RequestKyc({
    this.member,
    this.kycFile,
  });

  factory RequestKyc.fromJson(Map<String, dynamic> json) => RequestKyc(
        member: json["Member"] == null ? null : Member.fromJson(json["Member"]),
        kycFile: json["KycFile"] == null
            ? []
            : List<KycFile>.from(
                json["KycFile"]!.map((x) => KycFile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Member": member?.toJson(),
        "KycFile": kycFile == null
            ? []
            : List<dynamic>.from(kycFile!.map((x) => x.toJson())),
      };
}

class KycFile {
  String? type;
  String? file;

  KycFile({
    this.type,
    this.file,
  });

  factory KycFile.fromJson(Map<String, dynamic> json) => KycFile(
        type: json["type"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "file": file,
      };
}

class Member {
  String? fullname;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  String? beneficiaryRelationship;
  String? benefiaryName;
  String? benefiaryContact;

  Member({
    this.fullname,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.beneficiaryRelationship,
    this.benefiaryName,
    this.benefiaryContact,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        fullname: json["fullname"],
        bankName: json["bank_name"],
        bankAccountName: json["bank_account_name"],
        bankAccountNumber: json["bank_account_number"] ?? '',
        beneficiaryRelationship: json["beneficiary_relationship"],
        benefiaryName: json["benefiary_name"],
        benefiaryContact: json["benefiary_contact"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "bank_name": bankName,
        "bank_account_name": bankAccountName,
        "bank_account_number": bankAccountNumber,
        "beneficiary_relationship": beneficiaryRelationship,
        "benefiary_name": benefiaryName,
        "benefiary_contact": benefiaryContact,
      };
}
