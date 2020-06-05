import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Menu.dart';
import 'package:front_app_restaurant/src/pages/OrdersHistoryDetail.dart';
import 'package:front_app_restaurant/src/pages/Package.dart';
import 'package:front_app_restaurant/src/pages/personProfile.dart';
import 'package:front_app_restaurant/src/providers/ListOrders_Providers.dart';
import 'package:front_app_restaurant/src/providers/orders_Provider.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import '../providers/notification.dart';
import 'dart:async';

class RestaurantOrder extends StatefulWidget {
  @override
  _RestaurantOrderState createState() => _RestaurantOrderState();
}

class _RestaurantOrderState extends State<RestaurantOrder> {
  OrdersProviders ordersProviders;
  ListOrdersProviders listOrdersProviders;
  NotificationsProvider notificationProvider;
  UserInformation userInformation;

  List orders;
  Map userData;

  _RestaurantOrderState() {
    ordersProviders = OrdersProviders();
    listOrdersProviders = ListOrdersProviders();
    notificationProvider = NotificationsProvider();
    userInformation = UserInformation();
    userData = {};
    orders = [];
  }

  Future _cargarLista() async {
    userData = await userInformation.getUserInformation();
    listOrdersProviders
        .getOrdersByRestaurant(userData['restId'], 'LISTADO')
        .then((res) {
      setState(() {
        orders = res;
      });
    });
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      _cargarLista();
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    _cargarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos En Solicitud ',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Berlin Sans FB Demi',
              fontSize: 22),
        ),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          _simplePopup(),
        ],
        leading: IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.black,
            ),
            onPressed: () {
              final route = MaterialPageRoute(builder: (context) {
                return PersonProfile();
              });
              Navigator.push(context, route);
            }),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: orders.isEmpty 
               ? Center(child: Text('No hay pedidos pendientes por aceptar', style: TextStyle(fontSize: 16)))
               :ListView(
            children: <Widget>[
              listOrder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget listOrder() {
    for (int i = 0; i < orders.length; i++) {
      if (orders[i]['state'] == 'ACEPTADO') {
        orders.removeAt(i);
      } else if (orders[i]['state'] == 'ENVIADO') {
        orders.removeAt(i);
      } else if (orders[i]['state'] == 'CANCELADO') {
        orders.removeAt(i);
      }
    }

    return ListView.builder(
      physics: new NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orders == null ? 0 : orders.length,
      itemBuilder: (BuildContext context, int index) {
        return _cardOrder(
            orders[index]['menuName'].toString(),
            orders[index]['created_at'].toString().split('T')[0],
            orders[index]['address'],
            orders[index]['state'].toString(),
            orders[index]['orderId'].toString(),
            orders[index]['restId'].toString(),
            orders[index]['userId'].toString());
      },
    );
  }

  Widget _cardOrder(String nombre, String fecha, String address, String state,
      String orderId, String restId, String userId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 210,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.circular(5)),
            elevation: 9.0,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('Nombre del Plato : $nombre' +
                      '\nFecha De Pedido : $fecha' +
                      '\nNumero De Pedido : $orderId'),
                  subtitle: Text('Direccion de Pedido : $address' + '\n$state'),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10.0),
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.local_dining,
                            color: Colors.amber,
                          ),
                          tooltip: 'Solicitado',
                          onPressed: () {
                            notificationProvider.sendNotification(userId);
                            ordersProviders
                                .updateOrder(orderId, {'state': 'ACEPTADO'});

                            Navigator.of(context);

                            setState(() {
                              _cargarLista();
                            });
                          },
                        ),
                        Text('Aceptar Pedido')
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon:
                                Icon(Icons.remove_red_eye, color: Colors.green),
                            tooltip: 'Ver Detalle Del Pedido',
                            onPressed: () {
                              final route =
                                  MaterialPageRoute(builder: (context) {
                                return HistoryOrdersDetail(
                                  orderId: orderId,
                                  restId: restId,
                                );
                              });
                              Navigator.push(context, route);
                              setState(() {
                                _cargarLista();
                              });
                            }),
                        Text('Detalle Del Pedido')
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.remove_shopping_cart,
                                color: Colors.red),
                            tooltip: 'Rechazar Pedido',
                            onPressed: () {
                              ordersProviders
                                  .updateOrder(orderId, {'state': 'CANCELADO'});
                              Navigator.of(context);
                              setState(() {
                                _cargarLista();
                              });
                            }),
                        Text('Rechazar Pedido ')
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return list;
  }

  Widget _simplePopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: ListTile(
              leading: Icon(
                Icons.apps,
                color: Colors.red,
              ),
              title: Text('Gestionar Mis Paquetes'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return Package();
                });
                Navigator.push(context, route);
              },
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: ListTile(
              leading: Icon(
                Icons.restaurant_menu,
                color: Colors.red,
              ),
              title: Text('Gestionar Mi Menú'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return Menu();
                });
                Navigator.push(context, route);
              },
            ),
          ),
          PopupMenuItem(
            value: 3,
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text('Cerrar Sesión'),
              onTap: () {
               userInformation.signOff(context);
              },
            ),
          ),
        ],
      );
}
