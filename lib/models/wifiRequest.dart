// To parse this JSON data, do
//
//     final wifis = wifisFromJson(jsonString);

import 'dart:convert';

List<Wifis> wifisFromJson(String str) => List<Wifis>.from(json.decode(str).map((x) => Wifis.fromJson(x)));

String wifisToJson(List<Wifis> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wifis {
  String mac;
  double distance;

  Wifis({
    this.mac,
    this.distance,
  });

  factory Wifis.fromJson(Map<String, dynamic> json) => Wifis(
    mac: json["mac"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "mac": mac,
    "distance": distance,
  };
}
