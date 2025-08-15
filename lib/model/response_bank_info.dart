// To parse this JSON data, do
//
//     final responseBankInfo = responseBankInfoFromJson(jsonString);

import 'dart:convert';

ResponseBankInfo responseBankInfoFromJson(String str) =>
    ResponseBankInfo.fromJson(json.decode(str));

String responseBankInfoToJson(ResponseBankInfo data) =>
    json.encode(data.toJson());

class ResponseBankInfo {
  bool? success;
  List<DatumBank>? data;
  Member? member;
  dynamic message;

  ResponseBankInfo({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseBankInfo.fromJson(Map<String, dynamic> json) =>
      ResponseBankInfo(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<DatumBank>.from(
                json["data"]!.map((x) => DatumBank.fromJson(x))),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "member": member?.toJson(),
        "message": message,
      };
}

class DatumBank {
  String? type;
  int? id;
  String? name;
  String? accountNumber;
  String? accountName;
  String? description;
  dynamic url;
  String? file;
  int? status;
  DateTime? updatedAt;
  int? updatedBy;
  DateTime? createdAt;
  int? createdBy;
  dynamic typeName;

  DatumBank({
    this.type,
    this.id,
    this.name,
    this.accountNumber,
    this.accountName,
    this.description,
    this.url,
    this.file,
    this.status,
    this.updatedAt,
    this.updatedBy,
    this.createdAt,
    this.createdBy,
    this.typeName,
  });

  factory DatumBank.fromJson(Map<String, dynamic> json) => DatumBank(
        type: json["type"],
        id: json["id"],
        name: json["name"],
        accountNumber: json["account_number"],
        accountName: json["account_name"],
        description: json["description"],
        url: json["url"],
        file: json["file"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "name": name,
        "account_number": accountNumber,
        "account_name": accountName,
        "description": description,
        "url": url,
        "file": file,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "type_name": typeName,
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
