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
  final HttpClient _httpClient = new HttpClient();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Text(
          'Healthbook',
          style: TextStyle(fontFamily: 'Comfortaa', color: Colors.blue),
          textAlign: TextAlign.center,
          textScaleFactor: 2.5,
        ),
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
        final snackBar = new SnackBar(
          content: new Text('Connecting to backend...'),
          duration: Duration(seconds: 2),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        _isTokenStillValid(prefs.get(API_ADDRESS_KEY), prefs.get(USER_ID_KEY),
            prefs.get(TOKEN_KEY)).then((bool isValid) {
          isValid ? _navigateToHome() : _navigateToLogin();
        });
      } else {
        Future.delayed(Duration(seconds: 2), () {
          _navigateToLogin();
        });
      }
    })();
  }

  Future<bool> _isTokenStillValid(
      String apiAddress, String userId, String token) async {
    try {
      _httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http.IOClient ioClient = new http.IOClient(_httpClient);
      http.Response response = await ioClient
          .get("$apiAddress/user/$userId/medicalInformation", headers: {
        HttpHeaders.AUTHORIZATION: "Bearer $token",
        HttpHeaders.ACCEPT: ContentType.JSON.value
      }).timeout(Duration(seconds: 5));
      if (response != null && response.statusCode == 200) {
        print('Token still valid');
        return true;
      }
      return false;
    } on TimeoutException {
      print('Error while trying to validate token expiry (timeout)');
      return false;
    } on Exception {
      print(
          'Error while trying to validate token expiry (backend not available)');
      return Future.delayed(Duration(seconds: 2), () {
        return false;
      });
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
