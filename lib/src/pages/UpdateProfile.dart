import 'package:flutter/material.dart';
import 'package:front_app_restaurant/src/controllers/profile_Controller.dart';
import 'package:front_app_restaurant/src/pages/personProfile.dart';
import 'package:front_app_restaurant/src/providers/ListRestaurant_Provider.dart';
import 'package:front_app_restaurant/utils/UserInformation.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  
  ProfileController profileController;
  ListRestaurantProviders listRestaurantProviders;
  TextEditingController namerestaurant;
  TextEditingController direction;
  TextEditingController schedules;
  TextEditingController city2;
  TextEditingController phone;
  UserInformation userInformation;

  Map restaurant;
  Map userData;
  var nameRestaurant;
  var directions;
  var schedule;
  var city;
  var celphone;

  _UpdateProfilePageState() {
    profileController = ProfileController();
    listRestaurantProviders = ListRestaurantProviders();
    namerestaurant = TextEditingController();
    direction = TextEditingController();
    schedules = TextEditingController();
    city2 = TextEditingController();
    phone = TextEditingController();
    userInformation = UserInformation();
    userData = {};
  }

  Future updateProfile() async {
    userData = await userInformation.getUserInformation();
    listRestaurantProviders.getRestaurantId(userData['restId']).then((res) {
      setState(() {
        restaurant = res;
        nameRestaurant = restaurant['namerestaurant'];
        directions = restaurant['direction'];
        schedule = restaurant['schedule'];
        city = restaurant['city'];
        celphone = restaurant['celphone'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Informacion'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              final route = MaterialPageRoute(builder: ((context) {
                return PersonProfile();
              }));
              Navigator.push(context, route);
            }),
        backgroundColor: Colors.amber,
      ),
      body: ListView(
        children: <Widget>[
          Icon(
            Icons.restaurant_menu,
            color: Colors.amber,
            size: 200.0,
          ),
          _createInputText(
              nameRestaurant,
              Icon(
                Icons.restaurant,
                color: Colors.amber,
              ),
              namerestaurant),
          _createInputText(
              celphone, Icon(Icons.call, color: Colors.amber), phone),
          _createInputText(directions,
              Icon(Icons.store_mall_directory, color: Colors.amber), direction),
          _createInputText(
              schedule, Icon(Icons.timer, color: Colors.amber), schedules),
          _createInputText(
              city, Icon(Icons.location_city, color: Colors.amber), city2),
          _createButton(),
        ],
      ),
    );
  }

  Widget _createInputText(
      String hintext, Icon icon, TextEditingController control) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: TextFormField(
              controller: control,
              cursorColor: Colors.red,
              decoration: InputDecoration(
                hintText: hintext,
                icon: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: OutlineButton(
          highlightedBorderColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.20),
          child: Text('Guardar Cambios'),
          onPressed: () async {
            await _validation();
            profileController.update(context, {
              'namerestaurant': namerestaurant.text,
              'celphone': phone.text,
              'direction': direction.text,
              'schedule': schedules.text,
              'city': city2.text
            });
          },
        ),
      ),
    ]);
  }

  _validation() {
    if (namerestaurant.text.isEmpty) {
      namerestaurant.text = restaurant['namerestaurant'];
    }
    if (phone.text.isEmpty) {
      phone.text = restaurant['celphone'];
    }

    if (direction.text.isEmpty) {
      direction.text = restaurant['direction'];
    }
    if (schedules.text.isEmpty) {
      schedules.text = restaurant['schedule'];
    }
    if (city2.text.isEmpty) {
      city2.text = restaurant['city'];
    }
  }
}
