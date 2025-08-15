// To parse this JSON data, do
//
//     final responseCekDueDate = responseCekDueDateFromJson(jsonString);

import 'dart:convert';

ResponseCekDueDate responseCekDueDateFromJson(String str) =>
    ResponseCekDueDate.fromJson(json.decode(str));

String responseCekDueDateToJson(ResponseCekDueDate data) =>
    json.encode(data.toJson());

class ResponseCekDueDate {
  bool? success;
  Data? data;
  Member? member;
  String? message;

  ResponseCekDueDate({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseCekDueDate.fromJson(Map<String, dynamic> json) =>
      ResponseCekDueDate(
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
  int? memberId;
  int? loanId;
  int? status;
  int? statusloan;
  DateTime? duedate;

  Data({
    this.memberId,
    this.loanId,
    this.status,
    this.statusloan,
    this.duedate,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        memberId: json["member_id"],
        loanId: json["loan_id"],
        status: json["status"],
        statusloan: json["statusloan"],
        duedate:
            json["duedate"] == null ? null : DateTime.parse(json["duedate"]),
      );

  Map<String, dynamic> toJson() => {
        "member_id": memberId,
        "loan_id": loanId,
        "status": status,
        "statusloan": statusloan,
        "duedate":
            "${duedate!.year.toString().padLeft(4, '0')}-${duedate!.month.toString().padLeft(2, '0')}-${duedate!.day.toString().padLeft(2, '0')}",
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
