// To parse this JSON data, do
//
//     final responseGetService = responseGetServiceFromJson(jsonString);

import 'dart:convert';

ResponseGetService responseGetServiceFromJson(String str) =>
    ResponseGetService.fromJson(json.decode(str));

String responseGetServiceToJson(ResponseGetService data) =>
    json.encode(data.toJson());

class ResponseGetService {
  int? status;
  Data? data;

  ResponseGetService({
    this.status,
    this.data,
  });

  factory ResponseGetService.fromJson(Map<String, dynamic> json) =>
      ResponseGetService(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  List<Item>? items;
  Pagination? pagination;

  Data({
    this.items,
    this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
      };
}

class Item {
  int? id;
  String? provider;
  String? phonenumber;
  String? link;
  DateTime? createdAt;
  dynamic createdBy;
  DateTime? updatedAt;
  int? updatedBy;

  Item({
    this.id,
    this.provider,
    this.phonenumber,
    this.link,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        provider: json["provider"],
        phonenumber: json["phonenumber"],
        link: json["link"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider": provider,
        "phonenumber": phonenumber,
        "link": link,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  int? currentPage;
  int? perPage;

  Pagination({
    this.totalCount,
    this.pageCount,
    this.currentPage,
    this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        totalCount: json["total_count"],
        pageCount: json["page_count"],
        currentPage: json["current_page"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "page_count": pageCount,
        "current_page": currentPage,
        "per_page": perPage,
      };
}
