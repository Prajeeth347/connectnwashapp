import 'package:connectnwash/models/clothesmodel.dart';
import 'package:connectnwash/variables/variables.dart';
import 'package:http/http.dart' as http;

class ClothesService {
  String baseuri = Variables().baseuri;
  Future<List<Clothesmodel>?> getClothes() async {
    var clothesClient = http.Client();
    var clothesUri = Uri.parse("${baseuri}getclothprice");
    var clothesResponse = await clothesClient.get(clothesUri);
    var clothJson = clothesResponse.body;
    return clothesmodelFromJson(clothJson);
  }
}
