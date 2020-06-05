import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/controllers/Login_Controller.dart';
import 'package:front_app_restaurant/src/pages/Sign_In.dart';
//import 'package:front_app_restaurant/src/pages/register_Restaurant.dart';
import 'package:front_app_restaurant/src/providers/notification.dart';
import 'package:front_app_restaurant/src/services/Alert.dart';
import 'package:front_app_restaurant/src/services/Validators.dart';
import 'package:front_app_restaurant/src/controllers/Reset_Controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController loginController = LoginController();
  NotificationsProvider notificationsProvider = NotificationsProvider();
  ResetController resetController = ResetController();
  TextEditingController passwordConfirm = TextEditingController();
  Validators validator = Validators();
  Alerts alert = Alerts();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool _textvisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img1/rom1.jpg'),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.hardLight)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView(
                children: <Widget>[
                  Center(
                      child:
                          Image(image: AssetImage('assets/img1/logotipo.png'))),
                  _createInputEmail(),
                  _createInputPassword(),
                  _createButtonLogin(),
                  _createFlattButtonRegister('Registrate Aquí!!', 'register'),
                  _createFlattButtonResetPassword(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createInputEmail() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "  Usuario o Correo",
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createInputPassword() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            child: TextFormField(
              controller: password,
              obscureText: _textvisible,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _textvisible = !_textvisible),
                    icon: Icon(
                      _textvisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    iconSize: 25.0,
                    color: Colors.white,
                  ),
                  hintText: '  Contraseña',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.lock_open, color: Colors.white)),
              style: TextStyle(color: Colors.white, fontSize: 23),
            ),
            color: Colors.black.withOpacity(0.4),
          ),
        ],
      ),
    );
  }

  Widget _createButtonLogin() {
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
              onPressed: () {
                if (_validate2()) {
                  loginController.login(context, {
                    'authEmail': email.text.toLowerCase().trim(),
                    'authPassword': password.text.trim()
                  });
                }
              },
              child: Text('ENTRAR',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createFlattButtonRegister(String text, String route) {
    text = text;
    route = route;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        child: MaterialButton(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Berlin Sans FB Demi',
                fontSize: 22,
                height: 4,
                color: Colors.white.withAlpha(1000)),
          ),
          onPressed: () {
            final route = MaterialPageRoute(builder: (context) {
              return SingInPage();
            });
            Navigator.push(context, route);
          },
        ),
      ),
    );
  }

  Widget _createFlattButtonResetPassword() {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: Container(
        child: MaterialButton(
          child: Text(
            'olvidó su contraseña?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Berlin Sans FB Demi',
                fontSize: 22,
                color: Colors.white.withAlpha(1000)),
          ),
          onPressed: () {
            newpassword(context);
          },
        ),
      ),
    );
  }

  bool _validate2() {
    bool res = true;
    if (!validator.validateText(email.text)) {
      res = false;
      alert.errorAlert(context, 'Debe diligenciar todos los campos');
    } else if (!validator.validateEmail(email.text)) {
      res = false;
      alert.errorAlert(context, 'Email incorrecto, intente con otro');
    }

    return res;
  }

  void newpassword(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Stack(
            children: <Widget>[
              Container(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 130),
                      child: AlertDialog(
                        title: Center(child: Text('RESTABLECER CONTRASEÑA')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: email,
                              decoration: InputDecoration(
                                hintText: "   Correo Electrónico",
                                prefixIcon:
                                    Icon(Icons.email, color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              obscureText: true,
                              controller: name,
                              decoration: InputDecoration(
                                hintText: "   Nombre del Restaurante",
                                prefixIcon: Icon(Icons.security,
                                    color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            MaterialButton(
                              minWidth: 350,
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("Aceptar"),
                              onPressed: () {
                                if (_validate2()) {
                                  resetController.reset(context, {
                                    'authEmail':
                                        email.text.toLowerCase().trim(),
                                    'namerestaurant':
                                        name.text.toUpperCase().trim()
                                  }).then((res) {
                                    setState(() {
                                      email.clear();
                                      name.clear();
                                    });
                                  });
                                }
                              },
                            ),
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
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
