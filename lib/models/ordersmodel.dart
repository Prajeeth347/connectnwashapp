import 'dart:convert';

List<OrdersModel> ordersModelFromJson(String str) => List<OrdersModel>.from(
    json.decode(str).map((x) => OrdersModel.fromJson(x)));

String ordersModelToJson(List<OrdersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrdersModel {
  String id;
  String addressid;
  String custid;
  String empid;
  List<String> items;
  int status;
  DateTime datetime;
  int totalcost;
  List<dynamic> rejected;
  int v;

  OrdersModel({
    required this.id,
    required this.addressid,
    required this.custid,
    required this.empid,
    required this.items,
    required this.status,
    required this.datetime,
    required this.totalcost,
    required this.rejected,
    required this.v,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        id: json["_id"],
        addressid: json["addressid"],
        custid: json["custid"],
        empid: json["empid"],
        items: List<String>.from(json["items"].map((x) => x)),
        status: json["status"],
        datetime: DateTime.parse(json["datetime"]),
        totalcost: json["totalcost"],
        rejected: List<dynamic>.from(json["rejected"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "addressid": addressid,
        "custid": custid,
        "empid": empid,
        "items": List<dynamic>.from(items.map((x) => x)),
        "status": status,
        "datetime": datetime.toIso8601String(),
        "totalcost": totalcost,
        "rejected": List<dynamic>.from(rejected.map((x) => x)),
        "__v": v,
      };
}
