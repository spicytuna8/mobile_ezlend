// To parse this JSON data, do
//
//     final responseRegister = responseRegisterFromJson(jsonString);

import 'dart:convert';

ResponseRegister responseRegisterFromJson(String str) =>
    ResponseRegister.fromJson(json.decode(str));

String responseRegisterToJson(ResponseRegister data) =>
    json.encode(data.toJson());

class ResponseRegister {
  bool? success;
  DataRegister? data;
  String? message;

  ResponseRegister({
    this.success,
    this.data,
    this.message,
  });

  factory ResponseRegister.fromJson(Map<String, dynamic> json) =>
      ResponseRegister(
        success: json["success"],
        data: json["data"] == null ? null : DataRegister.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class DataRegister {
  String? email;
  String? phone;
  String? ic;
  String? verificationToken;

  DataRegister({
    this.email,
    this.phone,
    this.ic,
    this.verificationToken,
  });

  factory DataRegister.fromJson(Map<String, dynamic> json) => DataRegister(
        email: json["email"],
        phone: json["phone"],
        ic: json["ic"],
        verificationToken: json["verification_token"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "phone": phone,
        "ic": ic,
        "verification_token": verificationToken,
      };
}
