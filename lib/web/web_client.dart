import 'dart:async';

import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/test_data.dart';

class WebClient {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  Future<List<MedicalInformation>> fetchMedicalInformationEntries() async {
    return Future.delayed(
        delay,
        () => [
              TestDataProvider.testMedicalInfo1,
              TestDataProvider.testMedicalInfo2,
              TestDataProvider.testMedicalInfo3,
              TestDataProvider.testMedicalInfo4,
              TestDataProvider.testMedicalInfo1,
              TestDataProvider.testMedicalInfo2,
              TestDataProvider.testMedicalInfo3,
              TestDataProvider.testMedicalInfo4,
              TestDataProvider.testMedicalInfo1,
              TestDataProvider.testMedicalInfo2,
              TestDataProvider.testMedicalInfo3,
              TestDataProvider.testMedicalInfo4,
            ]);
  }

  Future<List<RelevantQueryData>> fetchRelevantQueries() async {
    return Future.delayed(
        delay,
        () => [
              TestDataProvider.testRelevantQueryData1,
            ]);
  }

  Future<bool> postNewMedicalInformationEntry(
      MedicalInformation medicalInfo) async {
    return Future.value(true);
  }

  Future<bool> postSharingPermissions(
      List<SharingPermission> permissions) async {
    return Future.value(true);
  }
}
