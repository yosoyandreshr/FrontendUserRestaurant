import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/RestaurantOrder.dart';
import 'package:front_app_restaurant/src/pages/PedidosCurso.dart';
import 'package:front_app_restaurant/src/pages/orderReject.dart';
import 'package:front_app_restaurant/src/pages/sendOrders.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../pages/PedidosCurso.dart';
import '../pages/RestaurantOrder.dart';
import '../pages/sendOrders.dart';
import '../pages/orderReject.dart';

void main() => runApp(MaterialApp(home: BottomNavBar()));

class BottomNavBar extends StatefulWidget {

  BottomNavBar();

  @override
  _BottomNavBarState createState() =>
      _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  GlobalKey _bottomNavigationKey = GlobalKey();

  Widget _showPage;

  _BottomNavBarState() {
    _showPage = new RestaurantOrder();
  }

  Widget _pageChoser(int page) {
    switch (page) {
      case 0:
        return RestaurantOrder();
      case 1:
        return PedidosCurso();
      case 2:
        return SendOrders();
      case 3:
        return OrderReject();
    }
    return Container(child: Text('page not found'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  Icons.fastfood,
                  size: 30,
                  color: Colors.black,
                ),
                Text('Solicitados',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 14))
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.cached, size: 30, color: Colors.black),
                Text('En Proceso',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 14))
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.motorcycle, size: 30, color: Colors.black),
                Text('Enviados',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 14))
              ],
            ),
            Column(
              children: <Widget>[
                Icon(Icons.cancel, size: 30, color: Colors.black),
                Text('Cancelados',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 14))
              ],
            ),
          ],
          color: Colors.amber,
          buttonBackgroundColor: Colors.amber,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _showPage = _pageChoser(index);
            });
          },
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: _showPage,
          ),
        ));
  }
}
