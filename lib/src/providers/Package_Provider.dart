import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';






class PackageProviders {


String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  PackageProviders(){
     uri = '$url/subscription';
    httpClient = HttpClient();
  }


  Future <List> getPackages(id) async {
    List packages;

    try {
      Response response = await httpClient.get('$uri/getPacksByRestaurant/$id');
      packages = jsonDecode(response.body);
      return packages;
    } catch (e) {
      print(e);
      return null;
    }
  }

Future <Map> createPackage(data) async {
    Map packages;

    
    try {
      Response response = await httpClient.post('$uri/createPackage', data);
      packages = jsonDecode(response.body);
      return packages;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future <Map> updateStatePackage( packageid, data) async {
    Map package;

    
    try {
      Response response = await httpClient.put('$uri/updatePackage/$packageid', data);
      package = jsonDecode(response.body);
      return package;
    } catch (e) {
      print(e);
      return null;
    }
  }


}