import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthbook/util/routes.dart';
import 'package:healthbook/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StartUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _StartUpPageState();
}

class _StartUpPageState extends State<StartUpPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: LinearProgressIndicator(
        value: null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.get(API_ADDRESS_KEY) != null &&
          prefs.get(TOKEN_KEY) != null &&
          prefs.get(USER_ID_KEY) != null) {
        // TODO enable token validation check
        /*_isTokenStillValid(prefs.get(API_ADDRESS_KEY), prefs.get(USER_ID_KEY),
            prefs.get(USER_ID_KEY)).then((bool isValid) {
          isValid ? _navigateToHome() : _navigateToLogin();
        });*/
        _navigateToHome();
      } else {
        _navigateToLogin();
      }
    })();
  }

  Future<bool> _isTokenStillValid(
      String apiAddress, String userId, String token) async {
    try {
      http.Response response = await http
          .get("$apiAddress/user/$userId/medicalInformation", headers: {
        HttpHeaders.AUTHORIZATION: "Bearer $token",
        HttpHeaders.ACCEPT: ContentType.JSON.value
      });
      if (response != null && response.statusCode == 200) {
        print('Api token still valid');
        return true;
      }
      print('Api token seems to be invalid, routing to login...');
      return false;
    } on Exception {
      print('Exception. Api token seems to be invalid, routing to login...');
      return false;
    }
  }

  _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
        context, HealthBookRoutes.home, (_) => false);
  }

  _navigateToLogin() {
    Navigator.pushNamedAndRemoveUntil(
        context, HealthBookRoutes.login, (_) => false);
  }
}
