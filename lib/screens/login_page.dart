import 'dart:async';

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
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final formKey = new GlobalKey<FormState>();
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
    AuthRequest request = new AuthRequest(_email, _password);
    print(jsonEncode(request.toJson()));
    try {
      http.Response response = await http.post(
          'http://$_apiAddress/api/auth/login',
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode(request.toJson()));
      if (response != null && response.statusCode != 200) {
        final snackBar = new SnackBar(
            content: new Text(response.statusCode == 401
                ? "Invalid credentials"
                : "Backend not avaiable, check connection"));
        _scaffoldKey.currentState.showSnackBar(snackBar);
        return false;
      } else {
        Map data = json.decode(response.body);
        final String token = data['token'];
        print(token);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(API_ADDRESS_KEY, _apiAddress);
        await prefs.setString(TOKEN_KEY, token);
        await prefs.setString(USER_ID_KEY, "12323144");
        return true;
      }
    } on Exception {
      final snackBar = new SnackBar(
          content: new Text("Backend not avaiable, check connection"));
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
        centerTitle: false,
      ),
      body: new Padding(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: [
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Server address'),
                validator: (val) =>
                    !val.contains(':') ? 'Invalid address' : null,
                onSaved: (val) => _apiAddress = val,
                initialValue: "88.116.5.26:4640",
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'E-mail'),
                validator: (val) =>
                    //!val.contains('@') || !val.contains(".") ? 'Invalid e-mail address' : null,
                    val.trim().isEmpty ? 'Invalid e-mail address' : null,
                onSaved: (val) => _email = val,
                initialValue: "PV20",
              ),
              new TextFormField(
                decoration: new InputDecoration(labelText: 'Password'),
                validator: (val) =>
                    val.length < 3 ? 'Password too short.' : null,
                onSaved: (val) => _password = val,
                obscureText: true,
                initialValue: "w9A7d7B2Xzhq74",
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
    );
  }
}
