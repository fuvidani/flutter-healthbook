import 'dart:async';
import 'package:healthbook/model/models.dart';

abstract class MedicalInfoRepository {
  Future<List<MedicalInformation>> loadMedicalInfoEntries();

  Future<bool> saveMedicalInformation(MedicalInformation medicalInfo);
}

abstract class MedicalQueryRepository {
  Future<List<RelevantQueryData>> loadRelevantQueries();

  Future<bool> saveSharingPermissions(List<SharingPermission> permissions);
}
