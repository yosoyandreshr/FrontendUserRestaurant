import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/personProfile.dart';
import 'package:front_app_restaurant/src/providers/Profile_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import 'package:front_app_restaurant/utils/token.dart';

class ProfileController {
  ProfileProvider profileProvider;
  Alerts alert;
  Token token;
  UserInformation userInformation;
  Map userData;

  ProfileController() {
    profileProvider = ProfileProvider();
    userInformation = UserInformation();
    userData = {};
    alert = Alerts();
    token = Token();
  }

  void update(BuildContext context,data) async {
    userData = await userInformation.getUserInformation();
    profileProvider.updateRestaurant(userData['restId'], data).then((res) {
      if (res == null) {
        alert.errorAlert(context, 'No se ha podido actualizar sus datos');
      } else {
        final route = MaterialPageRoute(builder: (context) {
          return PersonProfile();
        });
        Navigator.push(context, route);
      }
    }).catchError((e) {
      print(e);
      alert.errorAlert(context, 'error');
    });
  }
}
