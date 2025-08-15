// To parse this JSON data, do
//
//     final responseLogin = responseLoginFromJson(jsonString);

import 'dart:convert';

ResponseLogin responseLoginFromJson(String str) =>
    ResponseLogin.fromJson(json.decode(str));

String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

class ResponseLogin {
  bool? success;
  String? message;
  int? id;
  String? ic;
  String? email;
  String? token;

  ResponseLogin({
    this.success,
    this.message,
    this.id,
    this.ic,
    this.email,
    this.token,
  });

  factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
        success: json["success"],
        message: json["message"],
        id: json["id"],
        ic: json["ic"],
        email: json["email"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "id": id,
        "ic": ic,
        "email": email,
        "token": token,
      };
}
