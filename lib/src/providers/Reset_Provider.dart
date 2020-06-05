import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class ResetProvider {
   String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ResetProvider() {
    uri = '$url/restaurant';
    httpClient = HttpClient();
  }


  Future<Map> resetPassword(data) async {
    Map user;

    try {
      Response doc = await httpClient.post('$uri/resetPassword', data);
      user = jsonDecode(doc.body);

    } catch (err) {
      print(err);
    }

    return user;
  }

  Future<Map> changePassword(authId, data) async {
    Map user;
    try {
      Response response = await httpClient.put('$uri/updatePassword/$authId', data);
      user = jsonDecode(response.body);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
