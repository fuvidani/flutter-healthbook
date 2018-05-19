import 'package:flutter/material.dart';
import 'package:healthbook/app.dart';
import 'package:healthbook/repository/medicalInfo_repository.dart';
import 'package:healthbook/repository/medicalQuery_repository.dart';

void main() => runApp(new HealthBookApp(
      medicalInfoRepository: MedicalInfoRepositoryFlutter(),
      medicalQueryRepository: MedicalQueryRepositoryFlutter(),
    ));
