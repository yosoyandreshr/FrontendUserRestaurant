import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class SignInProvider {
  String url = Uri().getUri();
  HttpClient http;
  String uri;

  SignInProvider() {
    http = HttpClient();
    uri = '$url/Restaurant/save';
  }

  Future<Map> createRestaurant(data) async {
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

