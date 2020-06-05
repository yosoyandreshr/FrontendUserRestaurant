import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/providers/SignIn_Provider.dart';
import 'package:front_app_restaurant/src/providers/notification.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';



class SignInController {
  SignInProvider signInProvider;
  NotificationsProvider notificationsProvider;

  Alerts alert;
  var id;
  var token;
  bool charged = true;
  
  SignInController() {
    alert = Alerts();
    signInProvider = SignInProvider();
    notificationsProvider = NotificationsProvider();
  }
  create(BuildContext context, data, String confirm) async {
   
    if (confirm == data['authPassword'].toString()) {
      signInProvider.createRestaurant(data).then((res) async {
        id = res['restId'];
        notificationsProvider.saveNotification(
            {"restId": id, "tokenNotification": token}).then((res) async {});
           
      });
    } else {
      alert.errorAlert(context, 'Las Contraseñas no coinciden');
    }
  }
}
