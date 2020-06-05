import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_restaurant/src/providers/Login_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import 'package:front_app_restaurant/utils/token.dart';

import '../pages/personProfile.dart';
import '../providers/Reset_Provider.dart';


class LoginController {
  LoginProvider loginProvider;
  ListRestaurantProviders listRestaurantProviders;
  ResetProvider resetProvider ;
  UserInformation userInformation;
  Alerts alert;
  Token token;
  Map listRestaurantAuthId;
  Map restData;
  int restId;
  var idUser;

  LoginController() {
    alert = Alerts();
    token = Token();
    userInformation = UserInformation();
    loginProvider = LoginProvider();
    listRestaurantProviders = ListRestaurantProviders();
    resetProvider = ResetProvider();
  }

  void login(BuildContext context, data) {
    loginProvider.login(data).then((res) {
      idUser = res['authId'];

      listRestaurantProviders.getRestaurantAuthId(idUser).then((resp) {
        restId = resp['restid'];

        if (res == null) {
          alert.errorAlert(context,
              'No se ha podido iniciar sesión, revise sus credenciales');
        } else {
          userInformation.userData(res, data);
          Navigator.pushReplacementNamed(context, 'navigator');
        }
      });
    }).catchError((e) {
      alert.errorAlert(
          context, 'No se ha podido iniciar sesión, revise sus credenciales');
      Future.delayed(Duration(seconds: 1)).then((value) {
        userInformation.signOff(context);
      });
    });
  }

  void changePassword(BuildContext context, data, confirm) async {
    restData = await userInformation.getUserInformation();
    if (confirm == data['authPassword'].toString()) {
      resetProvider.changePassword(restData['authId'], data).then((res) {
        if (res == null) {
          alert.errorAlert(context, 'No se ha podido actualizar su contraseña');
        } else {
          token.setString('password', data['authPassword'].toString());
          final route = MaterialPageRoute(builder: (context) {
            return PersonProfile();
          });
          Navigator.push(context, route);
        }
      }).catchError((e) {
        print(e);
        alert.errorAlert(context, 'error');
      });
    } else {
      alert.errorAlert(context, 'Las Contraseñas no coinciden');
    }
  }
}
