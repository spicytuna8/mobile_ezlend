// To parse this JSON data, do
//
//     final requestLogDataContact = requestLogDataContactFromJson(jsonString);

import 'dart:convert';

RequestLogDataContact requestLogDataContactFromJson(String str) =>
    RequestLogDataContact.fromJson(json.decode(str));

String requestLogDataContactToJson(RequestLogDataContact data) =>
    json.encode(data.toJson());

class RequestLogDataContact {
  List<Contactlist>? contactlist;
  int? count;

  RequestLogDataContact({
    this.contactlist,
    this.count,
  });

  factory RequestLogDataContact.fromJson(Map<String, dynamic> json) =>
      RequestLogDataContact(
        count: json["count"],
        contactlist: json["contactlist"] == null
            ? []
            : List<Contactlist>.from(
                json["contactlist"]!.map((x) => Contactlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "contactlist": contactlist == null
            ? []
            : List<dynamic>.from(contactlist!.map((x) => x.toJson())),
      };
}

class Contactlist {
  String? name;
  String? number;

  Contactlist({
    this.name,
    this.number,
  });

  factory Contactlist.fromJson(Map<String, dynamic> json) => Contactlist(
        name: json["name"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
      };
}
