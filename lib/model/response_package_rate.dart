// To parse this JSON data, do
//
//     final responsePackageRateIndex = responsePackageRateIndexFromJson(jsonString);

import 'dart:convert';

ResponsePackageRateIndex responsePackageRateIndexFromJson(String str) =>
    ResponsePackageRateIndex.fromJson(json.decode(str));

String responsePackageRateIndexToJson(ResponsePackageRateIndex data) =>
    json.encode(data.toJson());

class ResponsePackageRateIndex {
  int? status;
  DataPackageRate? data;

  ResponsePackageRateIndex({
    this.status,
    this.data,
  });

  factory ResponsePackageRateIndex.fromJson(Map<String, dynamic> json) =>
      ResponsePackageRateIndex(
        status: json["status"],
        data: json["data"] == null
            ? null
            : DataPackageRate.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DataPackageRate {
  List<ItemPackageRate>? items;
  Pagination? pagination;

  DataPackageRate({
    this.items,
    this.pagination,
  });

  factory DataPackageRate.fromJson(Map<String, dynamic> json) =>
      DataPackageRate(
        items: json["items"] == null
            ? []
            : List<ItemPackageRate>.from(
                json["items"]!.map((x) => ItemPackageRate.fromJson(x))),
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

class ItemPackageRate {
  int? id;
  String? rate;
  int? returnDay;
  DateTime? createdAt;
  int? createdBy;
  DateTime? updatedAt;
  int? updatedBy;
  int? status;
  dynamic remark;

  ItemPackageRate({
    this.id,
    this.rate,
    this.returnDay,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.status,
    this.remark,
  });

  factory ItemPackageRate.fromJson(Map<String, dynamic> json) =>
      ItemPackageRate(
        id: json["id"],
        rate: json["rate"],
        returnDay: json["return_day"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rate": rate,
        "return_day": returnDay,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
        "status": status,
        "remark": remark,
      };
}

class Pagination {
  int? totalCount;
  int? pageCount;
  String? currentPage;
  String? perPage;

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
