import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Package.dart';
import 'package:front_app_restaurant/src/pages/personProfile.dart';
import 'package:front_app_restaurant/src/providers/ListOrders_Providers.dart';
import 'package:front_app_restaurant/src/providers/notification.dart';
import 'package:front_app_restaurant/src/providers/orders_Provider.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import 'dart:async';

class PedidosCurso extends StatefulWidget {
  @override
  _PedidosCursoState createState() => _PedidosCursoState();
}

class _PedidosCursoState extends State<PedidosCurso> {
  OrdersProviders ordersProviders;
  UserInformation userInformation;
  NotificationsProvider notificationsProvider;
  ListOrdersProviders listOrdersProviders;

  List orders;
  Map userData;

  _PedidosCursoState() {
    ordersProviders = OrdersProviders();
    userInformation = UserInformation();
    listOrdersProviders = ListOrdersProviders();
    notificationsProvider = NotificationsProvider();
    userData = {};
    orders = [];
  }

  Future processOrderUser() async {
    userData = await userInformation.getUserInformation();
    listOrdersProviders
        .getOrdersByRestaurant(userData['restId'], 'PROCESO')
        .then((res) {
      setState(() {
        orders = res;
      });
    });
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      processOrderUser();
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    processOrderUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pedidos En Preparación ',
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
               ? Center(child: Text('No hay pedidos en proceso', style: TextStyle(fontSize: 16)))
               :ListView(
            children: <Widget>[
              listOrder(),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.blue),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listOrder() {
    for (int i = 0; i < orders.length; i++) {
      if (orders[i]['state'] == 'SOLICITADO') {
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
            context,
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

  Widget _cardOrder(context, String nombre, String fecha, String address,
      String state, String orderId, String restId, String userId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          height: 200,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.motorcycle,
                            color: Colors.green,
                          ),
                          tooltip: 'Enviar Pedido',
                          onPressed: () {
                            notificationsProvider.sendNotification(userId);
                            ordersProviders
                                .updateOrder(orderId, {'state': 'ENVIADO'});
                            Navigator.of(context);

                            setState(() {
                              processOrderUser();
                            });
                          },
                        ),
                        Text('Enviar Pedido')
                      ],
                    ),
                    SizedBox(width: 10.0),
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
                  return Package();
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
