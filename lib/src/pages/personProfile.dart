import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/pages/UpdateProfile.dart';
import 'package:front_app_restaurant/src/providers/BottomNavBar.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';
import '../controllers/Login_Controller.dart';
import '../providers/ListRestaurant_Provider.dart';

class PersonProfile extends StatefulWidget {
  @override
  _PersonProfileState createState() => _PersonProfileState();
}

class _PersonProfileState extends State<PersonProfile> {
  ListRestaurantProviders listRestaurantProviders;
  LoginController resetController;
  UserInformation userInformation;
  TextEditingController password;
  TextEditingController passwordConfirm;

  Map restaurant;
  Map userData;

  var nameRestaurant;
  var phone;
  var directions;
  var images;
  var schedule;
  var city;

  _PersonProfileState() {
    listRestaurantProviders = ListRestaurantProviders();
    resetController = LoginController();
    userInformation = UserInformation();
    password = TextEditingController();
    passwordConfirm = TextEditingController();
    userData = {};
    nameRestaurant = '';
    phone = '';
    directions = '';
    images = '';
    schedule = '';
    city = '';
  }

  Future personProfileUser() async {
    userData = await userInformation.getUserInformation();
    listRestaurantProviders.getRestaurantId(userData['restId']).then((res) {
      setState(() {
        restaurant = res;
        nameRestaurant = restaurant['namerestaurant'];
        phone = restaurant['celphone'];
        directions = restaurant['direction'];
        images = restaurant['image'];
        schedule = restaurant['schedule'];
        city = restaurant['city'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    personProfileUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil del Usuario'),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          _simplePopup(),
        ],
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
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            listOrder(),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.amber),
              title: Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listOrder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Card(
        elevation: 10.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: FadeInImage(
                      image: NetworkImage(
                        images.toString() != null ? images.toString() : '',
                      ),
                      placeholder: AssetImage('assets/img2/vacio.png'),
                    ),
                  ),
                ),
              ],
            ),

            ListTile(
              title: Text('Información Personal',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Berlin Sans FB Demi',
                    fontSize: 26,
                  )),
            ),

            // Icon(Icons.person_pin,color: Colors.red,size: 200.0,),
            ListTile(
              leading: Icon(Icons.home, color: Colors.amber),
              title: Text('Nombre De Restaurante',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
              subtitle: Text('$nameRestaurant',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.phone_android, color: Colors.amber),
              title: Text('Teléfono De Restaurante',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
              subtitle: Text('$phone',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.map, color: Colors.amber),
              title: Text('Direccion de Restaurante',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
              subtitle: Text('$directions',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
            ),

            ListTile(
              leading: Icon(Icons.info, color: Colors.amber),
              title: Text('Atencion Al Cliente',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
              subtitle: Text('$schedule',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
            ),
            ListTile(
              leading: Icon(Icons.location_city, color: Colors.amber),
              title: Text('Ubicacion (Ciudad)',
                  style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
              subtitle: Text('$city',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Berlin Sans FB Demi',
                      fontSize: 18)),
            ),

            Container(
              height: 95,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Row(
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.red,
                      child: Text(
                        'Editar Informacion',
                        style: TextStyle(
                            fontFamily: 'Berlin Sans FB Demi',
                            fontSize: 14,
                            color: Colors.white.withAlpha(1000)),
                      ),
                      onPressed: () {
                        final route = MaterialPageRoute(builder: (context) {
                          return UpdateProfilePage();
                        });
                        Navigator.push(context, route);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
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
                Icons.apps,
                color: Colors.red,
              ),
              title: Text('Cambiar Contraseña'),
              onTap: () {
                changePassword(context);
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

      void changePassword(BuildContext context) {
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
                        title: Center(child: Text('CAMBIE SU CONTRASEÑA')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextField(
                              controller: password,
                              decoration: InputDecoration(
                                hintText: "   Nueva Contraseña",
                                prefixIcon:
                                    Icon(Icons.lock, color: Color(0xFFF44336)),
                              ),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            const SizedBox(height: 10.0),
                            TextField(
                              controller: passwordConfirm,
                              decoration: InputDecoration(
                                hintText: "   Confirme Contraseña",
                                prefixIcon:
                                    Icon(Icons.lock_open, color: Color(0xFFF44336)),
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
                              onPressed: () async {
                                
                                resetController.changePassword(context, {"authEmail": userData['email'],"authPassword": password.text}, passwordConfirm.text);
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
