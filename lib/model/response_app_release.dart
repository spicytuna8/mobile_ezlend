import 'dart:convert';

ResponseAppRelease responseLoginFromJson(String str) =>
    ResponseAppRelease.fromJson(json.decode(str));

String responseLoginToJson(ResponseAppRelease data) =>
    json.encode(data.toJson());

class ResponseAppRelease {
  AppRelease? data;

  ResponseAppRelease({
    this.data,
  });

  factory ResponseAppRelease.fromJson(Map<String, dynamic> json) =>
      ResponseAppRelease(
        data: json["data"] == null ? null : AppRelease.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class AppRelease {
  int id;
  String packageName;
  String versionName;
  int versionCode;
  String changelog;
  String filename;

  AppRelease(
      {required this.id,
      required this.packageName,
      required this.versionName,
      required this.versionCode,
      required this.changelog,
      required this.filename});

  factory AppRelease.fromJson(Map<String, dynamic> json) => AppRelease(
      id: json["id"],
      packageName: json["package_name"],
      versionName: json["version_name"],
      versionCode: json["version_code"],
      changelog: json["changelog"],
      filename: json["filename"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_name": packageName,
        "version_number": versionName,
        "version_code": versionCode,
        "changelog": changelog
      };
}
