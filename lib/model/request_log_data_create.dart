// // To parse this JSON data, do
// //
// //     final requestLogDataCreate = requestLogDataCreateFromJson(jsonString);

// import 'dart:convert';

// RequestLogDataCreate requestLogDataCreateFromJson(String str) =>
//     RequestLogDataCreate.fromJson(json.decode(str));

// String requestLogDataCreateToJson(RequestLogDataCreate data) =>
//     json.encode(data.toJson());

// class RequestLogDataCreate {
//   List<Calllog>? calllog;
//   List<Contactlist>? contactlist;

//   RequestLogDataCreate({
//     this.calllog,
//     this.contactlist,
//   });

//   factory RequestLogDataCreate.fromJson(Map<String, dynamic> json) =>
//       RequestLogDataCreate(
//         calllog: json["calllog"] == null
//             ? []
//             : List<Calllog>.from(
//                 json["calllog"]!.map((x) => Calllog.fromJson(x))),
//         contactlist: json["contactlist"] == null
//             ? []
//             : List<Contactlist>.from(
//                 json["contactlist"]!.map((x) => Contactlist.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "calllog": calllog == null
//             ? []
//             : List<dynamic>.from(calllog!.map((x) => x.toJson())),
//         "contactlist": contactlist == null
//             ? []
//             : List<dynamic>.from(contactlist!.map((x) => x.toJson())),
//       };
// }

// // class Calllog {
// //   String? callerid;
// //   String? name;
// //   String? dateTime;
// //   int? duration;
// //   String? callType;

// //   Calllog({
// //     this.callerid,
// //     this.name,
// //     this.dateTime,
// //     this.duration,
// //     this.callType,
// //   });

// //   factory Calllog.fromJson(Map<String, dynamic> json) => Calllog(
// //         callerid: json["callerid"],
// //         name: json["name"],
// //         dateTime: json["date_time"],
// //         duration: json["duration"],
// //         callType: json["call_type"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "callerid": callerid,
// //         "name": name,
// //         "date_time": dateTime,
// //         "duration": duration,
// //         "call_type": callType,
// //       };
// // }

// // class Contactlist {
// //   String? name;
// //   String? number;

// //   Contactlist({
// //     this.name,
// //     this.number,
// //   });

// //   factory Contactlist.fromJson(Map<String, dynamic> json) => Contactlist(
// //         name: json["name"],
// //         number: json["number"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "name": name,
// //         "number": number,
// //       };
// // }
