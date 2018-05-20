import 'dart:async';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/repository/repository.dart';
import 'package:healthbook/web/web_client.dart';

class MedicalInfoRepositoryFlutter implements MedicalInfoRepository {
  final WebClient webClient;

  const MedicalInfoRepositoryFlutter({
    this.webClient = const WebClient(),
  });

  @override
  Future<List<MedicalInformation>> loadMedicalInfoEntries() async {
    return webClient.fetchMedicalInformationEntries();
  }

  @override
  Future<bool> saveMedicalInformation(MedicalInformation medicalInfo) async {
    return webClient.postNewMedicalInformationEntry(medicalInfo);
  }
}
