// To parse this JSON data, do
//
//     final responseContact = responseContactFromJson(jsonString);

import 'dart:convert';

ResponseContact responseContactFromJson(String str) =>
    ResponseContact.fromJson(json.decode(str));

String responseContactToJson(ResponseContact data) =>
    json.encode(data.toJson());

class ResponseContact {
  bool? success;
  ResponseContactData? data;
  Member? member;
  String? message;

  ResponseContact({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseContact.fromJson(Map<String, dynamic> json) =>
      ResponseContact(
        success: json["success"],
        data: json["data"] == null
            ? null
            : ResponseContactData.fromJson(json["data"]),
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

class ResponseContactData {
  String? status;
  String? message;
  DataData? data;

  ResponseContactData({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseContactData.fromJson(Map<String, dynamic> json) =>
      ResponseContactData(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataData {
  int? id;
  dynamic calllog;
  List<Contactlist>? contactlist;
  DateTime? createdAt;
  int? createdBy;
  DateTime? updatedAt;
  int? updatedBy;
  int? memberId;

  DataData({
    this.id,
    this.calllog,
    this.contactlist,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.memberId,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        id: json["id"],
        calllog: json["calllog"],
        contactlist: json["contactlist"] == null
            ? []
            : List<Contactlist>.from(
                json["contactlist"]!.map((x) => Contactlist.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
        memberId: json["member_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "calllog": calllog,
        "contactlist": contactlist == null
            ? []
            : List<dynamic>.from(contactlist!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "member_id": memberId,
      };
}

class Contactlist {
  String? name;
  String? number;

  Contactlist({
    this.name,
    this.number,
  });

  factory Contactlist.fromJson(Map<String, dynamic> json) => Contactlist(
        name: json["name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
