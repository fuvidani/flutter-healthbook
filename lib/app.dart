import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/repository/repository.dart';
import 'package:healthbook/screens/home_page.dart';
import 'package:healthbook/screens/login_page.dart';
import 'package:healthbook/screens/startup_page.dart';
import 'package:healthbook/util/routes.dart';

class HealthBookApp extends StatefulWidget {
  final MedicalInfoRepository medicalInfoRepository;
  final MedicalQueryRepository medicalQueryRepository;

  HealthBookApp(
      {@required this.medicalInfoRepository,
      @required this.medicalQueryRepository});

  @override
  State<StatefulWidget> createState() => new HealthBookAppState();
}

class HealthBookAppState extends State<HealthBookApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Healthbook',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new StartUpPage(),
      routes: {
        HealthBookRoutes.home: (context) {
          return HomePage(
            title: "Healthbook Home",
            medicalQueryRepository: widget.medicalQueryRepository,
            medicalInfoRepository: widget.medicalInfoRepository,
          );
        },
        HealthBookRoutes.login: (context) {
          return LoginPage(title: 'Healthbook Login');
        },
      },
    );
  }
}
