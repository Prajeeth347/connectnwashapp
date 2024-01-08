import 'dart:convert';

List<Clothesmodel> clothesmodelFromJson(String str) => List<Clothesmodel>.from(
    json.decode(str).map((x) => Clothesmodel.fromJson(x)));

String clothesmodelToJson(List<Clothesmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Clothesmodel {
  String id;
  String name;
  int gender;
  int price;
  int? quantity;
  String image;
  int v;

  Clothesmodel({
    required this.id,
    required this.name,
    required this.gender,
    required this.price,
    this.quantity,
    required this.image,
    required this.v,
  });

  factory Clothesmodel.fromJson(Map<String, dynamic> json) => Clothesmodel(
        id: json["_id"],
        name: json["Name"],
        gender: json["Gender"],
        price: json["Price"],
        quantity: json["quantity"],
        image: json["Image"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "Name": name,
        "Gender": gender,
        "Price": price,
        "quantity": quantity,
        "Image": image,
        "__v": v,
      };
}
