import 'dart:async';
import 'dart:math';

import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/test_data.dart';

class WebClient {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  static Random random = new Random(12312423);

  Future<List<MedicalInformation>> fetchMedicalInformationEntries() async {
    return Future.delayed(
        delay,
        () => [
              TestDataProvider.testMedicalInfo1,
              TestDataProvider.testMedicalInfo2,
              TestDataProvider.testMedicalInfo3,
              TestDataProvider.testMedicalInfo4,
              TestDataProvider.testMedicalInfo5,
              TestDataProvider.testMedicalInfo6,
              TestDataProvider.testMedicalInfo7,
              TestDataProvider.testMedicalInfo8,
            ]);
  }

  Future<List<RelevantQueryData>> fetchRelevantQueries() async {
    return Future.delayed(
        delay,
        () => [
              TestDataProvider.testRelevantQueryData1,
              TestDataProvider.testRelevantQueryData2,
              TestDataProvider.testRelevantQueryData3,
              TestDataProvider.testRelevantQueryData4,
            ]);
  }

  Future<bool> postNewMedicalInformationEntry(
      MedicalInformation medicalInfo) async {
    print(
        "MedicalInfo (user Id: ${medicalInfo.userId}, title: ${medicalInfo.title}, description: ${medicalInfo.description}, tags: ${medicalInfo.tags}, image: omitted)");
    return Future.delayed(const Duration(seconds: 2), () => random.nextBool());
  }

  Future<bool> postSharingPermissions(
      List<SharingPermission> permissions) async {
    return Future.delayed(const Duration(seconds: 1), () => random.nextBool());
  }
}
