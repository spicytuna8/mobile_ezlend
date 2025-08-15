// To parse this JSON data, do
//
//     final requestLogDataLogFile = requestLogDataLogFileFromJson(jsonString);

import 'dart:convert';

RequestLogDataLogFile requestLogDataLogFileFromJson(String str) =>
    RequestLogDataLogFile.fromJson(json.decode(str));

String requestLogDataLogFileToJson(RequestLogDataLogFile data) =>
    json.encode(data.toJson());

class RequestLogDataLogFile {
  List<LogFile>? logFile;
  int? count;

  RequestLogDataLogFile({
    this.logFile,
    this.count,
  });

  factory RequestLogDataLogFile.fromJson(Map<String, dynamic> json) =>
      RequestLogDataLogFile(
        count: json["count"],
        logFile: json["LogFile"] == null
            ? []
            : List<LogFile>.from(
                json["LogFile"]!.map((x) => LogFile.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "LogFile": logFile == null
            ? []
            : List<dynamic>.from(logFile!.map((x) => x.toJson())),
      };
}

class LogFile {
  String? type;
  String? file;

  LogFile({
    this.type,
    this.file,
  });

  factory LogFile.fromJson(Map<String, dynamic> json) => LogFile(
        type: json["type"],
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "file": file,
      };
}
