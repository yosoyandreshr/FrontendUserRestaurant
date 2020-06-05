import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';

class MenuProvider {
  String url = Uri().getUri();
  String uri;
  HttpClient http;

  MenuProvider() {
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

  Future<List> optionmenu(menuId) async {
    
    try {
      Response resp1 = await http.get('$uri/option/$menuId');
      decodeData1 = json.decode(resp1.body);
      
      return decodeData1;
      
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<List> optionsBymenuId(menuId) async {
    
    try {
      Response resp1 = await http.get('$uri/Options/$menuId');
      decodeData1 = json.decode(resp1.body);
      
      return decodeData1;
      
    } catch (err) {
      print(err);
      return null;
    }
  }


  Future<Map> createMenu(data) async {
    Map menu;
    try {
      Response res = await http.post('$uri/menu/createMenu', data);
      menu = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return menu;
}

 Future<Map> createOption(data) async {
    Map option;
    try {
      Response res = await http.post('$uri/menu/createOption', data);
      option = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return option;
}

 Future<Map> createSubOption(data) async {
    Map suboption;
    try {
      Response res = await http.post('$uri/menu/createSubOption', data);
      suboption = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return suboption;
}

Future <Map> deleteSubOption(subid) async {
  Map suboption;
   try{
      Response res = await http.delete('$uri/menu/deleteSubOption/$subid');
      suboption = jsonDecode(res.body);

   }
   catch (err) {
      print(err);
    }
    return suboption;
 }

 Future <Map> updateMenu(menuid, body) async {
  Map menu;
   try{
      Response res = await http.put('$uri/menu/updateMenu/$menuid', body);
      menu = jsonDecode(res.body);

   }
   catch (err) {
      print(err);
    }
    return menu;
 }
}
