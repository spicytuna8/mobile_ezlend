// To parse this JSON data, do
//
//     final responsePaid = responsePaidFromJson(jsonString);

import 'dart:convert';

ResponsePaid responsePaidFromJson(String str) =>
    ResponsePaid.fromJson(json.decode(str));

String responsePaidToJson(ResponsePaid data) => json.encode(data.toJson());

class ResponsePaid {
  bool? success;
  Data? data;
  Member? member;
  String? message;

  ResponsePaid({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponsePaid.fromJson(Map<String, dynamic> json) => ResponsePaid(
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
  dynamic pay;
  String? rate;
  int? interest;
  String? loan;
  String? totalreceivedfromloans;
  int? status;
  int? statusloan;
  int? loanPackageId;
  int? loanPackageDetailId;

  Data({
    this.pay,
    this.rate,
    this.interest,
    this.loan,
    this.totalreceivedfromloans,
    this.status,
    this.statusloan,
    this.loanPackageId,
    this.loanPackageDetailId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pay: json["pay"],
        rate: json["rate"],
        interest: json["interest"],
        loan: json["loan"],
        totalreceivedfromloans: json["totalreceivedfromloans"],
        status: json["status"],
        statusloan: json["statusloan"],
        loanPackageId: json["loan_package_id"],
        loanPackageDetailId: json["loan_package_detail_id"],
      );

  Map<String, dynamic> toJson() => {
        "pay": pay,
        "rate": rate,
        "interest": interest,
        "loan": loan,
        "totalreceivedfromloans": totalreceivedfromloans,
        "status": status,
        "statusloan": statusloan,
        "loan_package_id": loanPackageId,
        "loan_package_detail_id": loanPackageDetailId,
      };
}

class Member {
  Member();

  factory Member.fromJson(Map<String, dynamic> json) => Member();

  Map<String, dynamic> toJson() => {};
}
