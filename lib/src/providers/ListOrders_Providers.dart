import 'dart:convert';
import 'package:http/http.dart';
import 'package:front_app_restaurant/src/services/HttpClient.dart';
import 'package:front_app_restaurant/src/configs/Url_Gateway.dart';


class ListOrdersProviders {
  String url = Uri().getUri();
  HttpClient httpClient;
  String uri;

  ListOrdersProviders() {
    uri = '$url/order';
    httpClient = HttpClient();
  }

  Future<List> getOrdersByUser(id, data) async {
    List orders;
    try {
      Response response = await httpClient.post('$uri/bill/list/$id',data);
      orders = jsonDecode(response.body);
      return orders;
    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<List> getOrdersByRestaurant(id,state) async {
    List orders;
   
    List process = [];
    

    if(state == 'LISTADO'){
      try {
      Response response = await httpClient.get('$uri/getOrdersByRestaurant/$id');
      orders = jsonDecode(response.body);
    

      for(int i =0; i<orders.length;i++){

        if(orders[i]['state'] == 'SOLICITADO'){

          process.add(orders[i]);

        }
        
      }
    } catch (e) {
      print(e);
      return null;
    }
    }
    else if (state == 'PROCESO') {
       try {
      Response response = await httpClient.get('$uri/getOrdersByRestaurant/$id');
      orders = jsonDecode(response.body);
    

      for(int i =0; i<orders.length;i++){

        if(orders[i]['state'] == 'ACEPTADO'){
         process.add(orders[i]);

        }
        
      }
    } catch (e) {
      print(e);
      return null;
    }


    }else if (state== 'FINALIZADO') {
      try {
         Response response = await httpClient.get('$uri/getOrdersByRestaurant/$id');
      orders = jsonDecode(response.body);
      
      for (int i = 0; i < orders.length; i++) {
        if (orders[i]['state'] == 'ENVIADO') {
        process.add(orders[i]);

        }
        
      }
      } catch (e) {
        print(e);
        return null;
      }
      
    }else if (state == 'RECHAZADO') {
       try {
         Response response = await httpClient.get('$uri/getOrdersByRestaurant/$id');
      orders = jsonDecode(response.body);
      
      for (int i = 0; i < orders.length; i++) {
        if (orders[i]['state'] == 'CANCELADO') {
        process.add(orders[i]);

        }
        
      }
      } catch (e) {
        print(e);
        return null;
      }
    }
    return process;
    
}

}



