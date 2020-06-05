import 'package:flutter/cupertino.dart';
import 'package:front_app_restaurant/utils/token.dart';

class UserInformation {
  Token token;

  UserInformation() {
    token = new Token();
  }

  void userData(body, data) {
    token.setToken(body['token']);
    token.setString('restId', body['restid'].toString());
    token.setString('email', data['authEmail'].toString());
    token.setString('password', data['authPassword'].toString());
  }

  Future<Map> getUserInformation() async {
    final userdata = {
      'restId': await token.getString('restId'),
      'email': await token.getString('email'),
      'password': await token.getString('password'),
    };
    return userdata;
  }

  Future signOff(context) {
    token.setToken('');
    token.setString('restId', '');
    token.setString('email', '');
    token.setString('password', '');
    // token.setString('direction', '');
    // token.setString('city', '');
    return Navigator.pushReplacementNamed(context, 'login');
  }
}
