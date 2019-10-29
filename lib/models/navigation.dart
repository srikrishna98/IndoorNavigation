// To parse this JSON data, do
//
//     final navigation = navigationFromJson(jsonString);

import 'dart:convert';

List<Navigation> navigationFromJson(String str) => List<Navigation>.from(json.decode(str).map((x) => Navigation.fromJson(x)));

String navigationToJson(List<Navigation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Navigation {
  String text;
  dynamic time;
  String code;

  Navigation({
    this.text,
    this.time,
    this.code,
  });

  factory Navigation.fromJson(Map<String, dynamic> json) => Navigation(
    text: json["text"],
    time: json["time"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "time": time,
    "code": code,
  };
}
