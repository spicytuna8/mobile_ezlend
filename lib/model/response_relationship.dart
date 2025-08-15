// To parse this JSON data, do
//
//     final responseGetRelationship = responseGetRelationshipFromJson(jsonString);

import 'dart:convert';

List<ResponseGetRelationship> responseGetRelationshipFromJson(String str) =>
    List<ResponseGetRelationship>.from(
        json.decode(str).map((x) => ResponseGetRelationship.fromJson(x)));

String responseGetRelationshipToJson(List<ResponseGetRelationship> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResponseGetRelationship {
  int? id;
  String? name;
  DateTime? createdAt;
  int? createdBy;
  DateTime? updatedAt;
  int? updatedBy;

  ResponseGetRelationship({
    this.id,
    this.name,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory ResponseGetRelationship.fromJson(Map<String, dynamic> json) =>
      ResponseGetRelationship(
        id: json["id"],
        name: json["name"],
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
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
      };
}
