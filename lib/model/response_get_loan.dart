// To parse this JSON data, do
//
//     final responseGetLoan = responseGetLoanFromJson(jsonString);

import 'dart:convert';

ResponseGetLoan responseGetLoanFromJson(String str) =>
    ResponseGetLoan.fromJson(json.decode(str));

String responseGetLoanToJson(ResponseGetLoan data) =>
    json.encode(data.toJson());

class ResponseGetLoan {
  bool? success;
  List<DatumLoan>? data;
  Member? member;
  dynamic message;

  ResponseGetLoan({
    this.success,
    this.data,
    this.member,
    this.message,
  });

  factory ResponseGetLoan.fromJson(Map<String, dynamic> json) =>
      ResponseGetLoan(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<DatumLoan>.from(
                json["data"]!.map((x) => DatumLoan.fromJson(x))),
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

class DatumLoan {
  int? id;
  String? fullname;
  String? packageName;
  String? loanamount;
  String? rate;
  int? returnday;
  String? totalreturn;
  String? totalamountdebit;
  int? status;
  int? statusloan;
  int? blacklist;
  DateTime? dateloan;
  dynamic remark;
  List<dynamic>? rejectedCode;
  List<LoanPackageDetail>? loanPackageDetails;

  DatumLoan({
    this.id,
    this.fullname,
    this.packageName,
    this.loanamount,
    this.rate,
    this.returnday,
    this.totalreturn,
    this.totalamountdebit,
    this.status,
    this.statusloan,
    this.dateloan,
    this.remark,
    this.rejectedCode,
    this.loanPackageDetails,
    this.blacklist,
  });

  factory DatumLoan.fromJson(Map<String, dynamic> json) => DatumLoan(
        id: json["id"],
        fullname: json["fullname"],
        packageName: json["package_name"],
        loanamount: json["loanamount"],
        rate: json["rate"],
        returnday: json["returnday"],
        totalreturn: json["totalreturn"],
        totalamountdebit: json["totalamountdebit"],
        status: json["status"],
        statusloan: json["statusloan"],
        blacklist: json["blacklist"],
        dateloan:
            json["dateloan"] == null ? null : DateTime.parse(json["dateloan"]),
        remark: json["remark"],
        rejectedCode: json["rejected_code"] == null
            ? []
            : List<dynamic>.from(json["rejected_code"]!.map((x) => x)),
        loanPackageDetails: json["loan_package_details"] == null
            ? []
            : List<LoanPackageDetail>.from(json["loan_package_details"]!
                .map((x) => LoanPackageDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "package_name": packageName,
        "loanamount": loanamount,
        "rate": rate,
        "returnday": returnday,
        "totalreturn": totalreturn,
        "totalamountdebit": totalamountdebit,
        "status": status,
        "statusloan": statusloan,
        "blacklist": blacklist,
        "dateloan":
            "${dateloan!.year.toString().padLeft(4, '0')}-${dateloan!.month.toString().padLeft(2, '0')}-${dateloan!.day.toString().padLeft(2, '0')}",
        "remark": remark,
        "rejected_code": rejectedCode == null
            ? []
            : List<dynamic>.from(rejectedCode!.map((x) => x)),
        "loan_package_details": loanPackageDetails == null
            ? []
            : List<dynamic>.from(loanPackageDetails!.map((x) => x.toJson())),
      };
}

class LoanPackageDetail {
  int? id;
  int? loanPackageId;
  dynamic walletTrx;
  String? amount;
  DateTime? createdAt;
  int? createdBy;
  DateTime? updatedAt;
  int? updatedBy;
  int? status;
  dynamic remark;
  int? bankinfo;

  LoanPackageDetail(
      {this.id,
      this.loanPackageId,
      this.walletTrx,
      this.amount,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy,
      this.status,
      this.remark,
      this.bankinfo});

  factory LoanPackageDetail.fromJson(Map<String, dynamic> json) =>
      LoanPackageDetail(
        id: json["id"],
        loanPackageId: json["loan_package_id"],
        walletTrx: json["wallet_trx"],
        amount: json["amount"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
        status: json["status"],
        remark: json["remark"],
        bankinfo: json["bankinfo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "loan_package_id": loanPackageId,
        "wallet_trx": walletTrx,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "status": status,
        "remark": remark,
        "bankinfo": bankinfo,
      };
}

class Member {
  int? id;
  String? fullname;
  String? ic;
  String? phone;

  Member({
    this.id,
    this.fullname,
    this.ic,
    this.phone,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        fullname: json["fullname"],
        ic: json["ic"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "ic": ic,
        "phone": phone,
      };
}
