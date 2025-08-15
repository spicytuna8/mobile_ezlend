// To parse this JSON data, do
//
//     final requestLogDataCallLog = requestLogDataCallLogFromJson(jsonString);

import 'dart:convert';

RequestLogDataCallLog requestLogDataCallLogFromJson(String str) =>
    RequestLogDataCallLog.fromJson(json.decode(str));

String requestLogDataCallLogToJson(RequestLogDataCallLog data) =>
    json.encode(data.toJson());

class RequestLogDataCallLog {
  List<Calllog>? calllog;
  int? count;

  RequestLogDataCallLog({
    this.calllog,
    this.count,
  });

  factory RequestLogDataCallLog.fromJson(Map<String, dynamic> json) =>
      RequestLogDataCallLog(
        count: json["count"],
        calllog: json["calllog"] == null
            ? []
            : List<Calllog>.from(
                json["calllog"]!.map((x) => Calllog.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "calllog": calllog == null
            ? []
            : List<dynamic>.from(calllog!.map((x) => x.toJson())),
      };
}

class Calllog {
  String? callerid;
  String? name;
  String? dateTime;
  int? duration;
  String? callType;

  Calllog({
    this.callerid,
    this.name,
    this.dateTime,
    this.duration,
    this.callType,
  });

  factory Calllog.fromJson(Map<String, dynamic> json) => Calllog(
        callerid: json["callerid"],
        name: json["name"],
        dateTime: json["date_time"],
        duration: json["duration"],
        callType: json["call_type"],
      );

  Map<String, dynamic> toJson() => {
        "callerid": callerid,
        "name": name,
        "date_time": dateTime,
        "duration": duration,
        "call_type": callType,
      };
}
