import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Menu.dart';
import 'package:front_app_restaurant/src/pages/MenuOptions.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/providers/Menu_Provider.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';

class MenuInactive extends StatefulWidget {
  @override
  _MenuInactiveState createState() => _MenuInactiveState();
}

class _MenuInactiveState extends State<MenuInactive> {
  
  UserInformation userInformation;
  MenuProvider menuProvider;

  List menu;
  List menuToshow;
  Map userData;

  _MenuInactiveState() {
    menuProvider = MenuProvider();
    userInformation = UserInformation();
    userData = {};
    menu = [];
    menuToshow = [];
  }

  Future menuInactiveUser() async {
    userData = await userInformation.getUserInformation();
    menuProvider.loadmenu(userData['restId']).then((res) {
      setState(() {
        menu = res;
        for (int i = 0; i < menu.length; i++) {
          if (menu[i]['state'] == 'INACTIVO') {
            menuToshow.add(menu[i]);
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    menuInactiveUser();
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
              return Menu();
            });
            Navigator.push(context, route);
          },
        ),
        actions: <Widget>[_simplePopup()],
      ),
      body: ListView(children: <Widget>[
        _createLabel(),
        _listMenus(),
      ]),
    );
  }

  Widget _listMenus() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menuToshow == null ? 0 : menuToshow.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardMenu(
              menuToshow[index]['image'].toString(),
              menuToshow[index]['menuName'],
              menuToshow[index]['value'].toString(),
              menuToshow[index]['menuId']);
        });
  }

  Widget _cardMenu(String imagens, String menuName, String value, int menuId) {
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
                image: NetworkImage(imagens),
              ),
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
                          Icons.add,
                          size: 30.0,
                        ),
                        color: Colors.red,
                        onPressed: () {
                          menuProvider.updateMenu(menuId, {'state': 'ACTIVO'});
                          final route = MaterialPageRoute(builder: (context) {
                            return Menu();
                          });
                          Navigator.push(context, route);
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
          'Menús Inactivos:',
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
          PopupMenuItem(
            value: 2,
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
}
