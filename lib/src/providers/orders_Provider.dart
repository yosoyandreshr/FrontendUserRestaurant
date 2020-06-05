import 'dart:convert';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/url_gateway.dart';

class OrdersProviders {
  Alerts alert = Alerts();
  
  String url= Uri().getUri();
  HttpClient http;
  String uri;
  
  OrdersProviders(){
    http = HttpClient();
    uri = '$url/order';
  }

 
  Map ordetsData;
  Map token;

 Future<Map> getOrders() async {
    try {
      Response res = await http.get(url);
      ordetsData= json.decode(res.body);

     token = ordetsData['token'];
      return ordetsData;

    } catch (err) {
      return null;
    }
  }
  Future<Map> createOrder(data) async {
    
    Map user;
    try {
      Response res = await http.post('$uri/createBill', data);
      user = jsonDecode(res.body);
      
    } catch (err) {
      print(err);
    }
    return user;
  }
  Future<Map> createDetailOrder(data) async {

    Map user;
    try {
      Response res = await http.post('$uri/createBillDetail', data);
      user = jsonDecode(res.body);
     
    } catch (err) {
      print(err);
    }
    return user;
  }
  Future<List> orderAll() async {

    List orderAll;
    try {
      Response res = await http.get('$uri/getOrderAllBasket');
      orderAll = jsonDecode(res.body);
    } catch (err) {
      print(err);
    }
    return orderAll;
  }

  Future<List> updateOrder(id,data) async {
    
        List order;
    try {
      Response res = await http.put('$uri/updateOrder/$id', data);
      order = jsonDecode(res.body);
      return order;
      
     
    } catch (err) {
      print(err);
    }

     
   
    return null;
  }



  Future<Map> getOrderActive(id) async {
    Map order;
    try {
      Response res = await http.get('$uri/ordersDetail/$id');
      order = jsonDecode(res.body);
      return order;
    } catch (error) {
      print(error);
      return null;
    }
  }


}