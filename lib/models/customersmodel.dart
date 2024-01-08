// To parse this JSON data, do
//
//     final findcust = findcustFromJson(jsonString);

import 'dart:convert';

List<Findcust> findcustFromJson(String str) =>
    List<Findcust>.from(json.decode(str).map((x) => Findcust.fromJson(x)));

String findcustToJson(List<Findcust> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Findcust {
  String? id;
  String? name;
  int? gender;
  int? mobile;
  String? email;
  String? dob;
  int? v;

  Findcust({
    this.id,
    this.name,
    this.gender,
    this.mobile,
    this.email,
    this.dob,
    this.v,
  });

  factory Findcust.fromJson(Map<String, dynamic> json) => Findcust(
        id: json["_id"],
        name: json["Name"],
        gender: json["Gender"],
        mobile: json["Mobile"],
        email: json["Email"],
        dob: json["DOB"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Name": name,
        "Gender": gender,
        "Mobile": mobile,
        "Email": email,
        "DOB": dob,
        "__v": v,
      };
}
