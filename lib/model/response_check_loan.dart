// To parse this JSON data, do
//
//     final responseCheckLoan = responseCheckLoanFromJson(jsonString);

import 'dart:convert';

ResponseCheckLoan responseCheckLoanFromJson(String str) =>
    ResponseCheckLoan.fromJson(json.decode(str));

String responseCheckLoanToJson(ResponseCheckLoan data) =>
    json.encode(data.toJson());

class ResponseCheckLoan {
  bool? success;
  Data? data;
  Member? member;
  String? message;
  String? loanamount;
  String? alreadypaid;
  int? notbeenpaidof;
  String? statusbalance;

  ResponseCheckLoan({
    this.success,
    this.data,
    this.member,
    this.message,
    this.loanamount,
    this.alreadypaid,
    this.notbeenpaidof,
    this.statusbalance,
  });

  factory ResponseCheckLoan.fromJson(Map<String, dynamic> json) =>
      ResponseCheckLoan(
        loanamount: json["loanamount"] ?? '',
        alreadypaid: json["alreadypaid"] ?? '',
        notbeenpaidof: json["notbeenpaidof"],
        statusbalance: json["statusbalance"] ?? '',
        success: json["success"] ?? false,
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        message: json["message"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "member": member?.toJson(),
        "message": message,
        "loanamount": loanamount,
        "alreadypaid": alreadypaid,
        "notbeenpaidof": notbeenpaidof,
        "statusbalance": statusbalance,
      };
}

class Data {
  dynamic totalmustbepaid;
  String? statusbalance;
  String? alreadypaid;

  Data({this.totalmustbepaid, this.statusbalance, this.alreadypaid});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalmustbepaid: json["totalmustbepaid"],
        statusbalance: json["statusbalance"] ?? '',
        alreadypaid: json["alreadypaid"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "totalmustbepaid": totalmustbepaid,
        "statusbalance": statusbalance,
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
