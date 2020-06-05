import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/controllers/SignIn_Controller.dart';
import 'package:front_app_restaurant/src/providers/notification.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/src/services/Validators.dart';
import 'package:front_app_restaurant/utils/Cloudinary_photo.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterRestaurant extends StatefulWidget {
  RegisterRestaurant();

  @override
  _RegisterRestaurantState createState() => _RegisterRestaurantState();
}

class _RegisterRestaurantState extends State<RegisterRestaurant> {
  SignInController signInController = SignInController();
  NotificationsProvider notificationsProvider = NotificationsProvider();

  Validators validator = Validators();
  Alerts alert = Alerts();

  TextEditingController namerestaurant = TextEditingController();
  TextEditingController celphone = TextEditingController();
  TextEditingController description = TextEditingController();

  TextEditingController direction = TextEditingController();
  TextEditingController schedule = TextEditingController();

  TextEditingController city = TextEditingController();
  String image;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  File picture;
  Cloudinary c = new Cloudinary();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img1/rom1.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.8), BlendMode.hardLight)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 950,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadiusDirectional.circular(8)),
                          elevation: 10.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Container(
                                      child: GestureDetector(
                                        onTap: _procesarImagen,
                                        child: Center(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 300,
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(Icons.photo_album,
                                                      color: Colors.black),
                                                  Text('Foto del Restaurante',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Berlin Sans FB Demi',
                                                          fontSize: 12)),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 0),
                                                    child: Container(
                                                      width: 300,
                                                      height: 250,
                                                      child: picture == null
                                                          ? Image.asset(
                                                              'assets/img3/load.gif')
                                                          : Image.file(picture),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextField(
                                controller: namerestaurant,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Nombre del Restaurante",
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: description,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Slogan de Restaurante",
                                  prefixIcon:
                                      Icon(Icons.edit, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: celphone,
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Telefono del Restaurante",
                                  prefixIcon: Icon(Icons.settings_cell,
                                      color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: direction,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Direccion del Restaurante",
                                  prefixIcon:
                                      Icon(Icons.map, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: schedule,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Horario De Atencion al Cliente",
                                  prefixIcon:
                                      Icon(Icons.av_timer, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: city,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Localizacion(ciudad)",
                                  prefixIcon: Icon(Icons.location_city,
                                      color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Correo",
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                obscureText: true,
                                controller: password,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                obscureText: true,
                                controller: passwordConfirm,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  hintText: "Confirmar Contraseña",
                                  prefixIcon:
                                      Icon(Icons.lock, color: Colors.amber),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              MaterialButton(
                                  minWidth: 350,
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: Text("Aceptar".toUpperCase()),
                                  onPressed: _submit),
                              MaterialButton(
                                minWidth: 350,
                                color: Colors.red,
                                textColor: Colors.white,
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _procesarImagen() async {
    var pictures = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      picture = pictures;
    });
  }

  void _submit() async {
    image = await c.uploadPhoto(picture);

    if (_validation()) {
      final confirm = passwordConfirm.text;
      signInController.create(
          context,
          {
            'namerestaurant': namerestaurant.text.toUpperCase(),
            'description': description.text,
            'celphone': celphone.text,
            'direction': direction.text,
            'schedule': schedule.text,
            'image': image,
            'city': city.text,
            'authEmail': email.text.toLowerCase(),
            'authPassword': password.text
          },
          confirm);
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
        !validator.validateText(password.text)) {
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
}
