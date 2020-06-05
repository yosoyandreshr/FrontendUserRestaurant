import 'package:flutter/material.dart';

import 'package:front_app_restaurant/src/pages/Login.dart';
import 'package:front_app_restaurant/src/pages/Menu.dart';
import 'package:front_app_restaurant/src/pages/OrdersHistoryDetail.dart';
import 'package:front_app_restaurant/src/pages/Package.dart';
import 'package:front_app_restaurant/src/pages/PedidosCurso.dart';
import 'package:front_app_restaurant/src/pages/Sign_In.dart';

import 'package:front_app_restaurant/src/pages/RestaurantOrder.dart';
import 'package:front_app_restaurant/src/pages/Splash.dart';
import 'package:front_app_restaurant/src/pages/UpdateProfile.dart';
import 'package:front_app_restaurant/src/pages/orderReject.dart';
import 'package:front_app_restaurant/src/pages/personProfile.dart';
import 'package:front_app_restaurant/src/pages/sendOrders.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/pages/register_Restaurant.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{

    'login': (BuildContext context) => LoginPage(),
    'search': (BuildContext context) => RestaurantOrder(),
    'pedidos': (BuildContext context) => PedidosCurso(),
    'send': (BuildContext context) => SendOrders(),
    'navigator': (BuildContext context) => BottomNavBar(),
    'reject': (BuildContext context) => OrderReject(),
    'order': (BuildContext context) => HistoryOrdersDetail(),
    'profile': (BuildContext context) => PersonProfile(),
    'sphash': (BuildContext context) => SplashRestaurant(),
    'registry': (BuildContext context) => SingInPage(),
    'update': (BuildContext context) => UpdateProfilePage(),
    'register': (BuildContext context) => RegisterRestaurant(),
    'menu': (BuildContext context) => Menu(),
    'package': (BuildContext context) => Package(),
    
  };
}
