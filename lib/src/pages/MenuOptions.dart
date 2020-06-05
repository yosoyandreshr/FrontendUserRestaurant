import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Menu.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/src/providers/Menu_Provider.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';

class MenuOptions extends StatefulWidget {
  final int idMenu;

  MenuOptions({this.idMenu});

  @override
  _MenuOptionsState createState() => _MenuOptionsState(idMenu: this.idMenu);
}

class _MenuOptionsState extends State<MenuOptions> {
  final int id;
  final String email;
  final int idMenu;
  MenuProvider menuProvider = MenuProvider();
  TextEditingController subOptionName = TextEditingController();
  TextEditingController optionName = TextEditingController();
  Alerts alerts;
  List options;
  List<String> nameOptions;
  List<String> nameSubOptions;
  

  _MenuOptionsState({this.id, this.email, this.idMenu}) {
    nameOptions = [];
    nameSubOptions = [];
    options = [];
    alerts = Alerts();
  }

  Future menuOptionUser() async {
    menuProvider.optionsBymenuId(idMenu).then((res) {
      setState(() {
        options = res;
        if (options.toString() == '[]') {
          alerts.errorAlert(context, 'Este menú no tiene opciones creadas');
        }
      });
    });
  }

  Future subOptionCreate(String idOption, String optionName) async {

    menuProvider.createSubOption({'optionId': idOption, 'subName': optionName});
    final route = MaterialPageRoute(builder: (context) {
      return MenuOptions(idMenu: idMenu);
    });
    Navigator.push(context, route);
  }

  Future refresh() async {
    final duration = new Duration(seconds: 1);
    new Timer(duration, () {
      menuOptionUser();
      
    });
    return Future.delayed(duration);
  }

  @override
  void initState() {
    super.initState();
    menuOptionUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          child: Text(
            'Opciones Del Menú',
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
      body: Container(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: ListView(children: <Widget>[
            // _createLabel(),
            _listMenus(),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear Opción',
        backgroundColor: Colors.blue[900],
        onPressed: () {
          newOption(context, idMenu.toString());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _listMenus() {
    return ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: options == null ? 0 : options.length,
        itemBuilder: (BuildContext context, int index) {
          return _cardOption(
              options[index]['optionName'],
              options[index]['subName'],
              options[index]['optionId'].toString(),
              options[index]['subOptionDetail']);
        });
  }

  Widget _cardOption(
      String optionname, String subname, String optionid, List subOptions) {
    final list = Container(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          elevation: 20.0,
          child: Column(children: <Widget>[
            ListTile(
              title: Text(
                'Opción: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
              subtitle: Text(
                '$optionname',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                'Sub Opciones: ',
                style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 18),
              ),
            ),
            listSubOption(subOptions),
            Column(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 30.0,
                    ),
                    color: Colors.green,
                    onPressed: () {
                      newSubOption(context, optionid);
                    }),
                Text(
                  'Agregar Una Sub Opción a  $optionname',
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18),
                )
              ],
            ),
            Divider(height: 20.0)
          ]),
        ),
      ),
    );
    return list;
  }

  Widget listSubOption(List subOptions) {
    List subOptionsToShow = [];

    for (int i = 0; i < subOptions.length; i++) {
      subOptionsToShow.add(subOptions[i]);
    }

    return subOptionsToShow.isEmpty
        ? Center(
            child: Text('No hay sub opciones', style: TextStyle(fontSize: 16)))
        : ListView.builder(
            physics: new NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: subOptionsToShow == null ? 0 : subOptionsToShow.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(subOptionsToShow[index]['subName']),
                trailing: IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      menuProvider.deleteSubOption(
                          subOptionsToShow[index]['subId'].toString());
                      final route = MaterialPageRoute(builder: (context) {
                        return MenuOptions(idMenu: idMenu);
                      });
                      Navigator.push(context, route);
                    }),
              );
            },
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
              title: Text('Crear Nueva Opción'),
              onTap: () {
                newOption(context, idMenu.toString());
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

  Future newSubOption(BuildContext context, String optionid) async {
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
                  controller: subOptionName,
                  decoration:
                      InputDecoration(hintText: 'Nombre De Sub Opción*'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
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
                  subOptionCreate(optionid.toString(),subOptionName.text.toUpperCase());
                }),
          ],
        );
      },
    );
  }

  Future newOption(BuildContext context, String menuid) async {
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
                  controller: optionName,
                  decoration: InputDecoration(hintText: 'Nombre De La Opción*'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
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
                  menuProvider.createOption({
                    'menuId': menuid,
                    'optionName': optionName.text.toUpperCase()
                  });
                  final route = MaterialPageRoute(builder: (context) {
                    return MenuOptions(idMenu: idMenu);
                  });
                  Navigator.push(context, route);
                  setState(() {});
                }),
          ],
        );
      },
    );
  }
}
