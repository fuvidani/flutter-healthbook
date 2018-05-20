import 'dart:async';

import 'package:healthbook/model/models.dart';

typedef Future<bool> MedicalInfoAdder(MedicalInformation medicalInfo);
typedef Future<bool> SharingPermissionUpdater(
    List<SharingPermission> permissions);
