import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class ProfileProvider {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ProfileProvider() {
    uri = '$url';
    httpClient = HttpClient();
  }

  Future<Map> updateRestaurant(id, data) async {
    Map restaurant;
    try {
      Response response = await httpClient.put('$uri/Restaurant/update/$id', data);
      restaurant = jsonDecode(response.body);
      return restaurant;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Map> changePassword(authId, data) async {
    Map user;
    try {
      Response response = await httpClient.put('$uri/change/$authId', data);
      user = jsonDecode(response.body);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

