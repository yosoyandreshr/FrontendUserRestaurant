import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/controllers/SignIn_Controller.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/src/services/Validators.dart';
import 'package:front_app_restaurant/utils/Cloudinary_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';

class SingInPage extends StatefulWidget {
  @override
  _SingInPageState createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  Alerts alert = Alerts();
  SignInController signInController = SignInController();
  ProgressDialog progressDialog;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  TextEditingController namerestaurant = TextEditingController();
  TextEditingController celphone = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController direction = TextEditingController();
  TextEditingController schedule = TextEditingController();

  TextEditingController city = TextEditingController();
  String image;
  File picture;
  Cloudinary c = new Cloudinary();

  Validators validator = Validators();
  bool charged = true;
  bool _textvisible = true;
  bool _textvisible2 = true;

  _SingInPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Container(
            child: Text(
              'Registro',
              style: TextStyle(color: Colors.black, fontSize: 30.0),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: ListView(children: <Widget>[
          _cardPhotoSelector(),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextFormField(
              controller: namerestaurant,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Nombre del Restaurante",
                prefixIcon: Icon(Icons.person, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: description,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Slogan de Restaurante",
                prefixIcon: Icon(Icons.edit, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: celphone,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Telefono del Restaurante",
                prefixIcon: Icon(Icons.settings_cell, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: direction,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Direccion del Restaurante",
                prefixIcon: Icon(Icons.map, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: schedule,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Horario De Atencion al Cliente",
                prefixIcon: Icon(Icons.av_timer, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: city,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Localizacion(ciudad)",
                prefixIcon: Icon(Icons.location_city, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: "Correo",
                prefixIcon: Icon(Icons.email, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              obscureText: _textvisible,
              controller: password,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _textvisible = !_textvisible),
                  icon: Icon(
                    _textvisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  iconSize: 25.0,
                  color: Colors.amber,
                ),
                hintText: "Contraseña",
                prefixIcon: Icon(Icons.lock, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              obscureText: _textvisible2,
              controller: passwordConfirm,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _textvisible2 = !_textvisible2),
                  icon: Icon(
                    _textvisible2 ? Icons.visibility_off : Icons.visibility,
                  ),
                  iconSize: 25.0,
                  color: Colors.amber,
                ),
                hintText: "Confirmar Contraseña",
                prefixIcon: Icon(Icons.lock, color: Colors.amber),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: MaterialButton(
                minWidth: 350,
                color: Colors.red,
                textColor: Colors.white,
                child: Text("Aceptar".toUpperCase()),
                onPressed: () {
                  _submit();
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: MaterialButton(
              minWidth: 350,
              color: Colors.red,
              textColor: Colors.white,
              child: Text("CANCELAR"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 20.0),
        ]));
  }

  Widget _cardPhotoSelector() {
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

  void progress() {
    progressDialog = new ProgressDialog(context);
    progressDialog.style(
      message: 'Registrando Restaurante',
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

  void _submit() async {
    setState(() {});
    if (_validation()) {
      final confirm = passwordConfirm.text;

      progress();
      progressDialog.show();

      image = await c.uploadPhoto(picture);

      signInController
          .create(
              context,
              {
                'namerestaurant': namerestaurant.text.toUpperCase(),
                'description': description.text.toLowerCase(),
                'celphone': celphone.text,
                'direction': direction.text.toUpperCase().trim(),
                'schedule': schedule.text,
                'image': image,
                'city': city.text.toUpperCase().trim(),
                'authEmail': email.text.toLowerCase(),
                'authPassword': password.text
              },
              confirm)
          .then((res) async {
        setState(() {});
        namerestaurant.clear();
        description.clear();
        celphone.clear();
        direction.clear();
        schedule.clear();
        image = '';
        city.clear();
        email.clear();
        password.clear();
        passwordConfirm.clear();

        Future.delayed(Duration(seconds: 1)).then((value) {
          progressDialog.hide().whenComplete(() {
            Navigator.popAndPushNamed(context, 'login');
          });
        });
      });
    }
  }

  bool _validation() {
    bool res = true;

    if (!validator.validateText(namerestaurant.text) ||
        !validator.validateText(celphone.text) ||
        !validator.validateText(description.text) ||
        !validator.validateText(direction.text) ||
        !validator.validateText(schedule.text) ||
        !validator.validateText(city.text) ||
        !validator.validateText(email.text) ||
        !validator.validateText(passwordConfirm.text) ||
        !validator.validateText(password.text) ||
        picture == null) {
      res = false;
      alert.errorAlert(context, 'Debe diligenciar todos los campos');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(context,
          'Email incorrecto, intente con otro : ej. Usuario@gmail.com');
    } else if (!validator.validatePassword(password.text) ||
        !validator.validatePassword(passwordConfirm.text)) {
      res = false;
      alert.errorAlert(context, 'La contraseña debe tener más de 4 caracteres');
    }

    return res;
  }

  void _opengallery() async {
    var pictures = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = pictures;
    });
  }
}
