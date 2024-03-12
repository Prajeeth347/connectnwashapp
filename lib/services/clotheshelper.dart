import 'dart:convert';

import 'package:connectnwash/models/clothesmodel.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClothesService {
  String baseuri = Variables().baseuri;
  Future<List<Clothesmodel>?> getClothes() async {
    var clothesClient = http.Client();
    var clothesUri = Uri.parse("${baseuri}getclothprice");
    var clothesResponse = await clothesClient.get(clothesUri);
    var clothJson = clothesResponse.body;
    return clothesmodelFromJson(clothJson);
  }

  Future<bool> placeOrder(List<Clothesmodel> cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var custid = prefs.getString('CNWUid');
    String baseuri = Variables().baseuri;
    var httpClient = http.Client();
    var createOrderURI = Uri.parse("${baseuri}createorder");
    List<String> items = [];
    if (cartItems.isNotEmpty) {
      cartItems.forEach((element) {
        items.add("${element.name} x ${element.quantity}");
      });
    }

    var empresponse = await httpClient.post(
      createOrderURI,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "totalcost": 200,
          "Custid": custid,
          "Addid": "6492b02780dfc55db8c2c020",
          "items": items,
        },
      ),
    );

    var empjson = empresponse.body;
    print('RESPONSE FROM API');
    print(empjson);
    print('RESPONSE STATUS ${empresponse.statusCode}');

    return empresponse.statusCode == 200;
  }
}
