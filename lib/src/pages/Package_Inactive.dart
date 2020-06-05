import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Package.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/providers/Package_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';

class PackageInactive extends StatefulWidget {
  @override
  _PackageInactiveState createState() => _PackageInactiveState();
}

class _PackageInactiveState extends State<PackageInactive> {
  PackageProviders packageProviders;
  UserInformation userInformation;
  Alerts alert;

  List packages;
  List packagesToShow;
  Map userData;

  _PackageInactiveState() {
    packageProviders = PackageProviders();
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
      });
    });
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
              return Package();
            });
            Navigator.push(context, route);
          },
        ),
        actions: <Widget>[_simplePopup()],
      ),
      body: ListView(
        children: <Widget>[
          _listPackages(),
        ],
      ),
    );
  }

  Widget _listPackages() {
    for (int i = 0; i < packages.length; i++) {
      if (packages[i]['state'] == 'INACTIVO') {
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
                      Icons.add_circle,
                      size: 50.0,
                    ),
                    color: Colors.green,
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
                                  Text('Desea Ofrecer De Nuevo Éste Paquete ?',
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
                                          packageid, {'state': 'ACTIVO'});
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
                Divider(height: 30.0),
                Text(
                  'Ofrecer De Nuevo',
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
              title: Text('Volver a Página Principal'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return BottomNavBar();
                });
                Navigator.push(context, route);
              },
            ),
          ),
        ],
      );
}
