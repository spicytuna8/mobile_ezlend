// To parse this JSON data, do
//
//     final responseLogDataCreate = responseLogDataCreateFromJson(jsonString);

import 'dart:convert';

ResponseLogDataCreate responseLogDataCreateFromJson(String str) =>
    ResponseLogDataCreate.fromJson(json.decode(str));

String responseLogDataCreateToJson(ResponseLogDataCreate data) =>
    json.encode(data.toJson());

class ResponseLogDataCreate {
  bool? success;
  ResponseLogDataCreateData? data;
  Member? member;
  String? message;

  ResponseLogDataCreate({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseLogDataCreate.fromJson(Map<String, dynamic> json) =>
      ResponseLogDataCreate(
        success: json["success"],
        data: json["data"] == null
            ? null
            : ResponseLogDataCreateData.fromJson(json["data"]),
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

class ResponseLogDataCreateData {
  String? status;
  String? message;
  DataData? data;

  ResponseLogDataCreateData({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseLogDataCreateData.fromJson(Map<String, dynamic> json) =>
      ResponseLogDataCreateData(
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
  List<Calllog>? calllog;
  List<Contactlist>? contactlist;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? createdBy;
  int? updatedBy;
  int? id;

  DataData({
    this.calllog,
    this.contactlist,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.id,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        calllog: json["calllog"] == null
            ? []
            : List<Calllog>.from(
                json["calllog"]!.map((x) => Calllog.fromJson(x))),
        contactlist: json["contactlist"] == null
            ? []
            : List<Contactlist>.from(
                json["contactlist"]!.map((x) => Contactlist.fromJson(x))),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "calllog": calllog == null
            ? []
            : List<dynamic>.from(calllog!.map((x) => x.toJson())),
        "contactlist": contactlist == null
            ? []
            : List<dynamic>.from(contactlist!.map((x) => x.toJson())),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "id": id,
      };
}

class Calllog {
  String? callerid;
  String? name;

  Calllog({
    this.callerid,
    this.name,
  });

  factory Calllog.fromJson(Map<String, dynamic> json) => Calllog(
        callerid: json["callerid"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "callerid": callerid,
        "name": name,
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
