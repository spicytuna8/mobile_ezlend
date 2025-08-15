// To parse this JSON data, do
//
//     final requestKyc = requestKycFromJson(jsonString);

import 'dart:convert';

RequestResubmitKyc requestKycFromJson(String str) =>
    RequestResubmitKyc.fromJson(json.decode(str));

String requestKycToJson(RequestResubmitKyc data) => json.encode(data.toJson());

class RequestResubmitKyc {
  MemberResubmit? memberResubmit;
  List<KycFileResubmit>? kycFileResubmit;

  RequestResubmitKyc({
    this.memberResubmit,
    this.kycFileResubmit,
  });

  factory RequestResubmitKyc.fromJson(Map<String, dynamic> json) =>
      RequestResubmitKyc(
        memberResubmit: json["Member"] == null
            ? null
            : MemberResubmit.fromJson(json["Member"]),
        kycFileResubmit: json["KycFile"] == null
            ? []
            : List<KycFileResubmit>.from(
                json["KycFile"]!.map((x) => KycFileResubmit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Member": memberResubmit?.toJson(),
        "KycFile": kycFileResubmit == null
            ? []
            : List<dynamic>.from(kycFileResubmit!.map((x) => x.toJson())),
      };
}

class KycFileResubmit {
  String? type;
  String? file;

  KycFileResubmit({
    this.type,
    this.file,
  });

  factory KycFileResubmit.fromJson(Map<String, dynamic> json) =>
      KycFileResubmit(
        type: json["type"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "file": file,
      };
}

class MemberResubmit {
  String? fullname;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  String? beneficiaryRelationship;
  String? benefiaryName;
  String? benefiaryContact;

  MemberResubmit({
    this.fullname,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.beneficiaryRelationship,
    this.benefiaryName,
    this.benefiaryContact,
  });

  factory MemberResubmit.fromJson(Map<String, dynamic> json) => MemberResubmit(
        fullname: json["fullname"],
        bankName: json["bank_name"],
        bankAccountName: json["bank_account_name"],
        bankAccountNumber: json["bank_account_number"] ?? '',
        beneficiaryRelationship: json["beneficiary_relationship"],
        benefiaryName: json["benefiary_name"],
        benefiaryContact: json["benefiary_contact"],
      );

  Map<String, dynamic> toJson() => {};
}
