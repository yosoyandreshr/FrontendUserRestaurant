import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/Menu.dart';
import 'package:front_app_restaurant/src/providers/Menu_Provider.dart';
import 'package:front_app_restaurant/utils/Cloudinary_photo.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:progress_dialog/progress_dialog.dart';

class CreateMenu extends StatefulWidget {
  @override
  _CreateMenuState createState() => _CreateMenuState();
}

class _CreateMenuState extends State<CreateMenu> {
  MenuProvider menuProvider;
  TextEditingController menu;
  TextEditingController value;
  UserInformation userInformation;
  ProgressDialog progressDialog;
  Cloudinary c;

  String image;
  File picture;
  Map userData;

  _CreateMenuState() {
    c = new Cloudinary();
    menuProvider = MenuProvider();
    menu = TextEditingController();
    value = TextEditingController();
    userInformation = UserInformation();
    userData = {};
  }

  Future createMenuUser() async {
    userData = await userInformation.getUserInformation();
  }

  @override
  void initState() {
    super.initState();
    createMenuUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Container(
          child: Text(
            'Crear Nuevo  Menú',
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
      ),
      body: ListView(children: <Widget>[
        _cardPhoto(),
        const SizedBox(height: 60.0),
        _createInputNameMenu(),
        const SizedBox(height: 20.0),
        _createInputValueMenu(),
        const SizedBox(height: 10.0),
        _createButton()
      ]),
    );
  }

  Widget _cardPhoto() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.grey[300],
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, -10.0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: GestureDetector(
              onTap: () {
                _opengallery();
                setState(() {});
              },
              child: Center(
                child: Container(
                  width: 300,
                  height: 240,
                  child: picture == null
                      ? Column(
                          children: <Widget>[
                            const SizedBox(height: 70.0),
                            Icon(
                              Icons.photo_camera,
                              size: 70.0,
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'Foto del Plato',
                              style: TextStyle(fontSize: 24.0),
                            ),
                          ],
                        )
                      : Image.file(picture),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _opengallery() async {
    _procesarImagen(ImageSource.gallery);
  }

  void _procesarImagen(ImageSource origen) async {
    picture = await ImagePicker.pickImage(source: origen);
    setState(() {});
  }

  Widget _createInputNameMenu() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: menu,
                decoration: InputDecoration(
                    hintText: 'Nombre Del Plato',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.restaurant, color: Colors.red)),
                style: TextStyle(color: Colors.black, fontSize: 23),
              ),
              //color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createInputValueMenu() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: value,
                decoration: InputDecoration(
                    hintText: 'Valor Del Plato',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.red)),
                style: TextStyle(color: Colors.black, fontSize: 23),
              ),
              //color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Registrando Menu',
      borderRadius: 15.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 20.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _createButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height: 60,
          child: Center(
            child: MaterialButton(
              height: 50,
              minWidth: 300,
              color: Colors.red,
              onPressed: () async {
                progress();
                progressDialog.show();
                image = await c.uploadPhoto(picture);
                menuProvider.createMenu({
                  'restId': userData['restId'].toString(),
                  'menuName': menu.text.toUpperCase(),
                  'image': image,
                  'value': value.text,
                  'state': 'EN PROCESO'
                }).then((res) {
                  setState(() {});

                  Future.delayed(Duration(seconds: 1)).then((value) {
                    progressDialog.hide().whenComplete(() {
                      Navigator.popAndPushNamed(context, 'menu');
                    });
                  });
                });
              },
              child: Text('GUARDAR',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }
}
