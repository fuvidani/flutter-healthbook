import 'package:flutter/material.dart';
import 'package:healthbook/util/routes.dart';
import 'package:healthbook/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {

  @override
  Widget build(BuildContext context) {
    return new Container();
  }

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get(API_ADDRESS_KEY) != null &&
          prefs.get(TOKEN_KEY) != null &&
          prefs.get(USER_ID_KEY) != null) {
        Navigator.pushNamedAndRemoveUntil(context, HealthBookRoutes.home, (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, HealthBookRoutes.login, (_) => false);
      }
    })();
  }
}