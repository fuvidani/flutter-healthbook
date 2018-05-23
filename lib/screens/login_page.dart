import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/constants.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final formKey = new GlobalKey<FormState>();
  final HttpClient _httpClient = new HttpClient();
  bool isLoading = false;
  String _apiAddress;
  String _email;
  String _password;

  void _submit() {
    final form = formKey.currentState;
    FocusScope.of(context).requestFocus(new FocusNode());
    if (form.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      _performLogin().then((bool success) {
        if (success) {
          Navigator.pushNamedAndRemoveUntil(
              context, HealthBookRoutes.home, (_) => false);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  Future<bool> _performLogin() async {
    _httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http.IOClient ioClient = new http.IOClient(_httpClient);
    final AuthRequest request = new AuthRequest(_email, _password);
    print(jsonEncode(request.toJson()));
    try {
      final http.Response response = await ioClient.post('$_apiAddress/auth',
          headers: {
            HttpHeaders.CONTENT_TYPE: ContentType.JSON.value,
            HttpHeaders.ACCEPT: ContentType.JSON.value,
          },
          body: jsonEncode(request.toJson()));
      final Map data = json.decode(response.body);
      if (response.statusCode != 200) {
        final snackBar = new SnackBar(
            content: new Text(response.statusCode == 401 ||
                    data['message'] != null &&
                        data['message'].toString() == 'Invalid Credentials'
                ? "Invalid credentials"
                : "Backend not available, check connection"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        return false;
      } else {
        final String token = data['token'];
        print(token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(API_ADDRESS_KEY, _apiAddress);
        await prefs.setString(TOKEN_KEY, token);
        await prefs.setString(USER_ID_KEY, "5b05529ba7b11b0001dddb53");
        return true;
      }
    } catch (e) {
      print(e);
      final snackBar = new SnackBar(
          content: new Text("Backend not available, check connection"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Padding(
        padding: EdgeInsets.all(0.0),
        child: new Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: new Column(
              children: [
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Server address'),
                  validator: (val) => !val.contains(':') ||
                          (!val.contains('http://') &&
                              !val.contains('https://'))
                      ? 'Invalid address'
                      : null,
                  onSaved: (val) => _apiAddress = val,
                  //initialValue: "http://88.116.5.26:4640",
                  initialValue: "https://128.130.249.111:8443",
                  enabled: !isLoading,
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'E-mail'),
                  validator: (val) =>
                      // TODO change validation pattern for production
                      //!val.contains('@') || !val.contains(".") ? 'Invalid e-mail address' : null,
                      val.trim().isEmpty ? 'Invalid e-mail address' : null,
                  onSaved: (val) => _email = val,
                  //initialValue: "PV20",
                  initialValue: "test.user@gmail.com",
                  enabled: !isLoading,
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: 'Password'),
                  validator: (val) =>
                      val.length < 3 ? 'Password too short.' : null,
                  onSaved: (val) => _password = val,
                  obscureText: true,
                  //initialValue: "w9A7d7B2Xzhq74",
                  initialValue: "password",
                  enabled: !isLoading,
                ),
                new Container(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            key: HealthBookKeys.loginLoading,
                          ))
                        : new RaisedButton(
                            onPressed: _submit,
                            child: new Text('Login',
                                style: new TextStyle(color: Colors.white)),
                            color: Colors.pinkAccent),
                    margin: new EdgeInsets.only(top: 16.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
