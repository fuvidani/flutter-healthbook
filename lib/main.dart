import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/routes.dart';
import 'package:healthbook/screens/home_page.dart';
import 'package:healthbook/screens/login_page.dart';
import 'package:healthbook/screens/startup_page.dart';

void main() => runApp(new HealthBookApp());

class HealthBookApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HealthBookAppState();
}

class HealthBookAppState extends State<HealthBookApp> {
  AppState appState = AppState.loading();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Healthbook',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new StartUpPage(),
      routes: {
        HealthBookRoutes.home: (context) {
          return new HomePage(appState: appState,title: "Healthbook Home");
        },
        HealthBookRoutes.login: (context) {
          return LoginPage(title: 'Healthbook Login');
        },
      },
    );
  }
}
