// To parse this JSON data, do
//
//     final responseGetListPayment = responseGetListPaymentFromJson(jsonString);

import 'dart:convert';

ResponseGetListPayment responseGetListPaymentFromJson(String str) =>
    ResponseGetListPayment.fromJson(json.decode(str));

String responseGetListPaymentToJson(ResponseGetListPayment data) =>
    json.encode(data.toJson());

class ResponseGetListPayment {
  List<Datum>? data;
  Link? link;
  Page? page;

  ResponseGetListPayment({
    this.data,
    this.link,
    this.page,
  });

  factory ResponseGetListPayment.fromJson(Map<String, dynamic> json) =>
      ResponseGetListPayment(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        link: json["link"] == null ? null : Link.fromJson(json["link"]),
        page: json["page"] == null ? null : Page.fromJson(json["page"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "link": link?.toJson(),
        "page": page?.toJson(),
      };
}

class Datum {
  int? id;
  int? memberId;
  String? amount;
  int? paymentId;
  dynamic expiredAt;
  dynamic remark;
  String? transNo;
  dynamic cancelNote;
  dynamic rejectedCode;
  String? rejectedNote;
  dynamic trxHash;
  int? status;
  int? paymentType;
  DateTime? updatedAt;
  int? updatedBy;
  DateTime? createdAt;
  int? createdBy;
  dynamic cardAccountId;
  dynamic cardId;
  dynamic currency;
  dynamic amountTopup;
  dynamic amountFee;
  dynamic fee;
  dynamic feeCost;
  dynamic amountCard;
  dynamic cardCost;
  dynamic domainId;
  int? loanPackageDetailId;

  Datum({
    this.id,
    this.memberId,
    this.amount,
    this.paymentId,
    this.expiredAt,
    this.remark,
    this.transNo,
    this.cancelNote,
    this.rejectedCode,
    this.rejectedNote,
    this.trxHash,
    this.status,
    this.paymentType,
    this.updatedAt,
    this.updatedBy,
    this.createdAt,
    this.createdBy,
    this.cardAccountId,
    this.cardId,
    this.currency,
    this.amountTopup,
    this.amountFee,
    this.fee,
    this.feeCost,
    this.amountCard,
    this.cardCost,
    this.domainId,
    this.loanPackageDetailId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        memberId: json["member_id"],
        amount: json["amount"],
        paymentId: json["payment_id"],
        expiredAt: json["expired_at"],
        remark: json["remark"],
        transNo: json["trans_no"],
        cancelNote: json["cancel_note"],
        rejectedCode: json["rejected_code"],
        rejectedNote: json["rejected_note"],
        trxHash: json["trx_hash"],
        status: json["status"],
        paymentType: json["payment_type"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        cardAccountId: json["card_account_id"],
        cardId: json["card_id"],
        currency: json["currency"],
        amountTopup: json["amount_topup"],
        amountFee: json["amount_fee"],
        fee: json["fee"],
        feeCost: json["fee_cost"],
        amountCard: json["amount_card"],
        cardCost: json["card_cost"],
        domainId: json["domain_id"],
        loanPackageDetailId: json["loan_package_detail_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "member_id": memberId,
        "amount": amount,
        "payment_id": paymentId,
        "expired_at": expiredAt,
        "remark": remark,
        "trans_no": transNo,
        "cancel_note": cancelNote,
        "rejected_code": rejectedCode,
        "rejected_note": rejectedNote,
        "trx_hash": trxHash,
        "status": status,
        "payment_type": paymentType,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "card_account_id": cardAccountId,
        "card_id": cardId,
        "currency": currency,
        "amount_topup": amountTopup,
        "amount_fee": amountFee,
        "fee": fee,
        "fee_cost": feeCost,
        "amount_card": amountCard,
        "card_cost": cardCost,
        "domain_id": domainId,
        "loan_package_detail_id": loanPackageDetailId,
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

class Link {
  First? self;
  First? first;
  First? last;

  Link({
    this.self,
    this.first,
    this.last,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        self: json["self"] == null ? null : First.fromJson(json["self"]),
        first: json["first"] == null ? null : First.fromJson(json["first"]),
        last: json["last"] == null ? null : First.fromJson(json["last"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self?.toJson(),
        "first": first?.toJson(),
        "last": last?.toJson(),
      };
}

class First {
  String? href;

  First({
    this.href,
  });

  factory First.fromJson(Map<String, dynamic> json) => First(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class Page {
  int? totalCount;
  int? pageCount;
  int? currentPage;
  int? perPage;

  Page({
    this.totalCount,
    this.pageCount,
    this.currentPage,
    this.perPage,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        totalCount: json["totalCount"],
        pageCount: json["pageCount"],
        currentPage: json["currentPage"],
        perPage: json["perPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "pageCount": pageCount,
        "currentPage": currentPage,
        "perPage": perPage,
      };
}
