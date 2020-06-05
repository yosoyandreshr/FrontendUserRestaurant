import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class TodayMenuProvider {
  String url = Uri().getUri();
  String uri;
  HttpClient http;

  TodayMenuProvider() {
    http = HttpClient();
    uri = "$url/menu";
  }
List decodeData1;
  Future<List> loadmenu(id) async {
    List decodeData;
    try {
      Response resp = await http.get('$uri/list/$id');
      decodeData = json.decode(resp.body);
      return decodeData;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List> optionmenu(id) async {
    
    try {
      Response resp1 = await http.get('$uri/option/$id');
      decodeData1 = json.decode(resp1.body);
      
      return decodeData1;
      
    } catch (err) {
      print(err);
      return null;
    }
  }


  Future<List> suboption(id) async {
    List decodeData;
    try {
      Response resp1 = await http.get('$uri/subOption/$id');
      decodeData = json.decode(resp1.body);
      return decodeData;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
