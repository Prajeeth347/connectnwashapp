import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(
    json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  String id;
  String custid;
  String address;
  int pincode;
  String city;
  double latitude;
  double longitude;
  int v;

  AddressModel({
    required this.id,
    required this.custid,
    required this.address,
    required this.pincode,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.v,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["_id"],
        custid: json["Custid"],
        address: json["Address"],
        pincode: json["Pincode"],
        city: json["City"],
        latitude: json["Latitude"]?.toDouble(),
        longitude: json["Longitude"]?.toDouble(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Custid": custid,
        "Address": address,
        "Pincode": pincode,
        "City": city,
        "Latitude": latitude,
        "Longitude": longitude,
        "__v": v,
      };
}
