import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/providers/orders_Provider.dart';

class HistoryOrdersDetail extends StatefulWidget {
  final String restId;
  final String orderId;
  HistoryOrdersDetail({this.restId, this.orderId});

  @override
  _HistoryOrdersDetailState createState() =>
      _HistoryOrdersDetailState(restId: this.restId, orderId: this.orderId);
}

class _HistoryOrdersDetailState extends State<HistoryOrdersDetail> {
  OrdersProviders ordersProvider = OrdersProviders();
  String restId;
  final String orderId;
  final String id;
  final String email;

  var menuName;
  var value;
  var address;
  var subName;
  List orderDetail;
  Map order;

  _HistoryOrdersDetailState({this.restId, this.orderId, this.id, this.email}) {
    menuName = '';
    value = '';
    address = '';
    subName = '';
  }

  Future orderHistoryDetail() async {
    ordersProvider.getOrderActive(orderId).then((res) {
      setState(() {
        order = res;
        menuName = order['menuName'];
        value = order['price'];
        address = order['address'];
        orderDetail = order['orderDetail'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    orderHistoryDetail();
  }

  Widget textSubname() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orderDetail == null ? 0 : orderDetail.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text(orderDetail[index]['subName']));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Descripcion del pedido'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListView(children: <Widget>[
          Card(
            elevation: 9.0,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.fastfood,
                  size: 80,
                  color: Colors.amber,
                ),
                ListTile(
                  title: Text('Menú :  $menuName',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 20)),
                ),
                ListTile(
                  title: Text('Precio: $value ',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 20)),
                ),
                ListTile(
                  title: Text(
                    'Direccion : $address ',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Berlin Sans FB Demi',
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text('La Elección fue: ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 34)),
                ),
                textSubname(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
