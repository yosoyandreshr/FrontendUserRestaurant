import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Create_Menu.dart';
import 'package:front_app_restaurant/src/pages/MenuOptions.dart';
import 'package:front_app_restaurant/src/pages/Menu_Inactive.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/providers/Menu_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  MenuProvider menuProvider;
  UserInformation userInformation;
  Alerts alerts;

  List menu;
  List menuToshow;
  Map userData;

  _MenuState() {
    menuProvider = MenuProvider();
    userInformation = UserInformation();
    userData = {};
    alerts = Alerts();
    menu = [];
    menuToshow = [];
  }

  Future menuUser() async {
    userData = await userInformation.getUserInformation();
    menuProvider.loadmenu(userData['restId']).then((res) {
      setState(() {
        menu = res;

        if (menu.toString() == '[]') {
          alerts.errorAlert(context, 'No Hay Menús Activos');
        }

        for (int i = 0; i < menu.length; i++) {
          if (menu[i]['state'] == 'ACTIVO' ||
              menu[i]['state'] == 'EN PROCESO') {
            menuToshow.add(menu[i]);
          }
        }
      });
    });
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      menuUser();
      menu = [];
      menuToshow = [];
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    menuUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          child: Text(
            'Gestión Del Menú',
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
          child: ListView(children: <Widget>[
            _createLabel(),
            _listMenus(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear Menú',
        backgroundColor: Colors.blue[900],
        onPressed: () {
          final route = MaterialPageRoute(builder: (context) {
            return CreateMenu();
          });
          Navigator.push(context, route);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listMenus() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menuToshow == null ? 0 : menuToshow.length,
        itemBuilder: (BuildContext context, int index) {
          if (menuToshow[index]['state'] == 'ACTIVO') {
            return _cardMenuActive(
                menuToshow[index]['image'].toString(),
                menuToshow[index]['menuName'],
                menuToshow[index]['value'].toString(),
                menuToshow[index]['menuId']);
          } else {
            return _cardMenuInProcess(
                menuToshow[index]['image'].toString(),
                menuToshow[index]['menuName'],
                menuToshow[index]['value'].toString(),
                menuToshow[index]['menuId']);
          }
        });
  }

  Widget _cardMenuActive(
      String imagens, String menuName, String value, int menuId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Center(
                  child: FadeInImage(
                    image: NetworkImage(imagens),
                    placeholder: AssetImage('assets/img3/cargandoBlanco.gif'),
                    fadeInDuration: Duration(seconds: 2),
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.blue,
              indent: 30.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Text(
                'Nombre Del Menú : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$menuName',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor Del Menú: ',
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
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30.0,
                        ),
                        color: Colors.green,
                        onPressed: () {
                          final route = MaterialPageRoute(builder: (context) {
                            return MenuOptions(idMenu: menuId);
                          });
                          Navigator.push(context, route);
                        }),
                    Text(
                      'ver Opciones De Menú',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 50.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: 30.0,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          menuProvider
                              .updateMenu(menuId, {'state': 'INACTIVO'});
                          final route = MaterialPageRoute(builder: (context) {
                            return Menu();
                          });
                          Navigator.push(context, route);
                        }),
                    Text(
                      'Inactivar',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            Divider(height: 20.0)
          ]),
        ),
      ),
    );
    return list;
  }

  Widget _cardMenuInProcess(
      String imagens, String menuName, String value, int menuId) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                Center(
                  child: FadeInImage(
                    image: NetworkImage(imagens),
                    placeholder: AssetImage('assets/img3/cargandoBlanco.gif'),
                    fadeInDuration: Duration(seconds: 2),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.blue,
              indent: 30.0,
              endIndent: 20.0,
            ),
            ListTile(
              title: Text(
                'Nombre Del Menú : ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$menuName',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Valor Del Menú: ',
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
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add,
                          size: 30.0,
                        ),
                        color: Colors.green,
                        onPressed: () {
                          final route = MaterialPageRoute(builder: (context) {
                            return MenuOptions(
                              idMenu: menuId,
                            );
                          });
                          Navigator.push(context, route);
                        }),
                    Text(
                      'ver Opciones De Menú',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 50.0,
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          size: 30.0,
                        ),
                        color: Colors.red,
                        onPressed: () async {
                          List options = [];
                          await menuProvider
                              .optionsBymenuId(menuId)
                              .then((res) {
                            options = res;
                          });

                          if (options.isNotEmpty) {
                            menuProvider
                                .updateMenu(menuId, {'state': 'ACTIVO'});
                            final route = MaterialPageRoute(builder: (context) {
                              return Menu();
                            });
                            Navigator.push(context, route);
                          } else {
                            alerts.errorAlert(context,
                                'Debe Crear Mínimo 3 Opciones Para Activar');
                          }
                        }),
                    Text(
                      'Activar',
                      style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Berlin Sans FB Demi',
                          fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            Divider(height: 20.0)
          ]),
        ),
      ),
    );
    return list;
  }

  Widget _createLabel() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Menús Activos:',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Berlin Sans FB Demi',
              fontSize: 34),
        ),
      ),
    );
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
              title: Text('Crear Nuevo Menú'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return CreateMenu();
                });
                Navigator.push(context, route);
              },
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: ListTile(
              leading: Icon(
                Icons.create_new_folder,
                color: Colors.red,
              ),
              title: Text('Ver Menús Inactivos'),
              onTap: () {
                final route = MaterialPageRoute(builder: (context) {
                  return MenuInactive();
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
              title: Text('Volver A Página Principal'),
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
