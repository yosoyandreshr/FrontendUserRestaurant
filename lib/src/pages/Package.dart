import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Package_Inactive.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/providers/Package_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';

class Package extends StatefulWidget {
  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  PackageProviders packageProviders;
  TextEditingController value;
  TextEditingController description;
  TextEditingController balance;
  UserInformation userInformation;
  Alerts alert;

  List packages;
  List packagesToShow;
  Map userData;

  _PackageState() {
    packageProviders = PackageProviders();
    value = TextEditingController();
    description = TextEditingController();
    balance = TextEditingController();
    userInformation = UserInformation();
    alert = Alerts();
    packages = [];
    packagesToShow = [];
    userData = {};
  }

  Future _cargarlista() async {
    userData = await userInformation.getUserInformation();
    packageProviders.getPackages(userData['restId']).then((res) {
      setState(() {
        packages = res;
        if (packages.toString() == '[]') {
          alert.errorAlert(context, 'No hay Paquetes Creados');
        }
      });
    });
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      packages = [];
      packagesToShow = [];
      _cargarlista();
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    _cargarlista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          child: Text(
            'Gestión De Paquetes',
            style: TextStyle(color: Colors.black),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            final route = MaterialPageRoute(builder: (context) {
              return BottomNavBar();
            });
            Navigator.push(context, route);
          },
        ),
        actions: <Widget>[_simplePopup()],
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(
            children: <Widget>[
              _listPackages(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear Paquete',
        backgroundColor: Colors.blue[900],
        onPressed: () {
          newPackage(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listPackages() {
    for (int i = 0; i < packages.length; i++) {
      if (packages[i]['state'] == 'ACTIVO') {
        packagesToShow.add(packages[i]);
      }
    }

    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: packagesToShow == null ? 0 : packagesToShow.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardPackage(
              packagesToShow[index]['packageId'].toString(),
              packagesToShow[index]['description'].toString(),
              packagesToShow[index]['subvalue'].toString(),
              packagesToShow[index]['balance'].toString());
        });
  }

  Widget _cardPackage(
      String packageid, String description, String value, String balance) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            Center(
              child: Image(
                image: AssetImage('assets/img1/promociones.jpg'),
              ),
            ),
            Divider(
              color: Colors.blue,
              indent: 30.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Text(
                'Nombre Del Paquete : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$description',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor Del Paquete: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$value',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Recibes : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                ' $balance',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            Column(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 50.0,
                    ),
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Image.asset('assets/img1/logoD.png'),
                                  ),
                                  Text('Desea Dejar De Ofrecer Éste Paquete ?',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Berlin Sans FB Demi',
                                          fontSize: 20)),
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    child: Text('SI',
                                        style: TextStyle(color: Colors.blue)),
                                    onPressed: () {
                                      packageProviders.updateStatePackage(
                                          packageid, {'state': 'INACTIVO'});
                                      _listPackages();
                                      final route =
                                          MaterialPageRoute(builder: (context) {
                                        return Package();
                                      });
                                      Navigator.push(context, route);
                                    }),
                                FlatButton(
                                    child: Text('NO',
                                        style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          });
                    }),
                Text(
                  'No Ofrecer Más',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18),
                )
              ],
            ),
            Divider(height: 30.0)
          ]),
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
                Icons.create_new_folder,
                color: Colors.red,
              ),
              title: Text('Crear Nuevo Paquete'),
              onTap: () {
                newPackage(context);
              },
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: ListTile(
              leading: Icon(
                Icons.local_activity,
                color: Colors.red,
              ),
              title: Text('Paquetes Inactivos'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return PackageInactive();
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
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ),
        ],
      );

  Future newPackage(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            constraints: BoxConstraints(minWidth: 230.0, minHeight: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Divider(
                  thickness: 2,
                ),
                TextField(
                  controller: description,
                  decoration:
                      InputDecoration(hintText: 'Descripción Del Paquete*'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: value,
                  decoration: InputDecoration(hintText: 'Valor a Pagar*'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: balance,
                  decoration: InputDecoration(hintText: 'Valor Recibido*'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('CANCELAR',
                    style: TextStyle(color: Color(0xFFF44336))),
                onPressed: () {
                  Navigator.pop(context);
                }),
            FlatButton(
                child:
                    Text('ACEPTAR', style: TextStyle(color: Color(0xFFF44336))),
                onPressed: () {
                  packageProviders.createPackage({
                    'restId': userData['restId'].toString(),
                    'description': description.text.toUpperCase(),
                    'subvalue': value.text,
                    'balance': balance.text,
                    'state': 'ACTIVO'
                  });
                  Navigator.popAndPushNamed(context, 'package');
                }),
          ],
        );
      },
    );
  }
}
