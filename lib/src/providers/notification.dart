import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/url_gateway.dart';

class NotificationsProvider{

  String url = Uri().getUri();
  HttpClient http;
  String uri;

  NotificationsProvider() {
    http = HttpClient();
    uri = '$url/notification';
  }

  Future<Map> saveNotification(data) async{
    Map token;
    try{

      Response res = await http.post('$uri/saveToken', data);
      token = jsonDecode(res.body);

    }catch(error){
      print(error);
    }
    return token;
  }

  Future<Map> sendNotification(id) async{
    Map token;
    try{
      Response res = await http.get('$uri/sendNotification/$id');
      token = jsonDecode(res.body);
    }catch(error){
      print(error);
    }
    return token;
  }

}