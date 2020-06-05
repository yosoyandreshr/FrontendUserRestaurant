import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class LoginProvider {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  LoginProvider() {
    http = HttpClient();
    uri = '$url/restaurant/login';
  }

  Future<Map> login(data) async {
    Map restaurant;
    try {
      Response res = await http.post('$uri', data);
      restaurant = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return restaurant;
  }
}
