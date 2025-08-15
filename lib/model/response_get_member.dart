// To parse this JSON data, do
//
//     final responseGetMember = responseGetMemberFromJson(jsonString);

import 'dart:convert';

ResponseGetMember responseGetMemberFromJson(String str) =>
    ResponseGetMember.fromJson(json.decode(str));

String responseGetMemberToJson(ResponseGetMember data) =>
    json.encode(data.toJson());

class ResponseGetMember {
  bool? success;
  Data? data;
  Member? member;
  dynamic message;

  ResponseGetMember({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseGetMember.fromJson(Map<String, dynamic> json) =>
      ResponseGetMember(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "member": member?.toJson(),
        "message": message,
      };
}

class Data {
  int? id;
  String? email;
  String? fullname;
  String? username;
  String? bankName;
  String? bankAccountName;
  String? bankAccountNumber;
  dynamic docId;
  int? docType;
  String? ic;
  int? status;
  Map<String, dynamic>? kyc;

  Data({
    this.id,
    this.email,
    this.fullname,
    this.username,
    this.bankName,
    this.bankAccountName,
    this.bankAccountNumber,
    this.docId,
    this.docType,
    this.ic,
    this.status,
    this.kyc,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        email: json["email"],
        fullname: json["fullname"],
        username: json["username"],
        bankName: json["bank_name"],
        bankAccountName: json["bank_account_name"],
        bankAccountNumber: json["bank_account_number"],
        docId: json["doc_id"],
        docType: json["doc_type"],
        ic: json["ic"],
        status: json["status"],
        kyc: json["kyc"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "fullname": fullname,
        "username": username,
        "bank_name": bankName,
        "bank_account_name": bankAccountName,
        "bank_account_number": bankAccountNumber,
        "doc_id": docId,
        "doc_type": docType,
        "ic": ic,
        "status": status,
        "kyc": kyc,
      };
}

class Kyc {
  int? id;
  int? mId;
  String? file;
  String? ext;
  int? size;
  int? noOrder;
  int? type;
  int? status;
  dynamic remark;
  DateTime? createdAt;
  int? createdBy;
  dynamic rejectedCode;
  dynamic rejectedNote;

  Kyc({
    this.id,
    this.mId,
    this.file,
    this.ext,
    this.size,
    this.noOrder,
    this.type,
    this.status,
    this.remark,
    this.createdAt,
    this.createdBy,
    this.rejectedCode,
    this.rejectedNote,
  });

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
        id: json["id"],
        mId: json["m_id"],
        file: json["file"],
        ext: json["ext"],
        size: json["size"],
        noOrder: json["no_order"],
        type: json["type"],
        status: json["status"],
        remark: json["remark"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        rejectedCode: json["rejected_code"],
        rejectedNote: json["rejected_note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "m_id": mId,
        "file": file,
        "ext": ext,
        "size": size,
        "no_order": noOrder,
        "type": type,
        "status": status,
        "remark": remark,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "rejected_code": rejectedCode,
        "rejected_note": rejectedNote,
      };
}

class RejectedCodeElement {
  int? id;
  String? content;

  RejectedCodeElement({
    this.id,
    this.content,
  });

  factory RejectedCodeElement.fromJson(Map<String, dynamic> json) =>
      RejectedCodeElement(
        id: json["id"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
