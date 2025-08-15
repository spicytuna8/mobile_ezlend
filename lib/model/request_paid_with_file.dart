// To parse this JSON data, do
//
//     final requestPaidWithFile = requestPaidWithFileFromJson(jsonString);

import 'dart:convert';

RequestPaidWithFile requestPaidWithFileFromJson(String str) =>
    RequestPaidWithFile.fromJson(json.decode(str));

String requestPaidWithFileToJson(RequestPaidWithFile data) =>
    json.encode(data.toJson());

class RequestPaidWithFile {
  Topup? topup;
  List<TopupFile>? topupFile;

  RequestPaidWithFile({
    this.topup,
    this.topupFile,
  });

  factory RequestPaidWithFile.fromJson(Map<String, dynamic> json) =>
      RequestPaidWithFile(
        topup: json["Topup"] == null ? null : Topup.fromJson(json["Topup"]),
        topupFile: json["TopupFile"] == null
            ? []
            : List<TopupFile>.from(
                json["TopupFile"]!.map((x) => TopupFile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Topup": topup?.toJson(),
        "TopupFile": topupFile == null
            ? []
            : List<dynamic>.from(topupFile!.map((x) => x.toJson())),
      };
}

class Topup {
  int? loanPackageDetailId;
  int? paymentId;

  Topup({
    this.loanPackageDetailId,
    this.paymentId,
  });

  factory Topup.fromJson(Map<String, dynamic> json) => Topup(
        loanPackageDetailId: json["loan_package_detail_id"],
        paymentId: json["payment_id"],
      );

  Map<String, dynamic> toJson() => {
        "loan_package_detail_id": loanPackageDetailId,
        "payment_id": paymentId,
      };
}

class TopupFile {
  String? file;

  TopupFile({
    this.file,
  });

  factory TopupFile.fromJson(Map<String, dynamic> json) => TopupFile(
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
      };
}
