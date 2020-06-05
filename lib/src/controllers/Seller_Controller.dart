import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/providers/Seller_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';

class SellerRequestController {
  SellerProvider sellerProvider;
  Alerts alert;

  SellerRequestController() {
    alert = Alerts();
    sellerProvider = SellerProvider();
  }

  request(BuildContext context, data) {
    sellerProvider.request(data).then((res) {
      alert.successAlert(
          context, 'Hemos enviado la información a su correo electrónico');
    }).catchError((e) {
      print(e);
      alert.errorAlert(context, 'error');
    });
  }
}
