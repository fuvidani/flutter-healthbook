import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/constants.dart';
import 'package:healthbook/util/test_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WebClient {
  final Duration delay;

  const WebClient([this.delay = const Duration(milliseconds: 3000)]);

  static Random random = new Random(12312423);

  Future<List<MedicalInformation>> fetchMedicalInformationEntries() async {
    // return _performRemoteCallForEntries();
    return _returnTestMedicalInfoEntries();
  }

  Future<List<RelevantQueryData>> fetchRelevantQueries() async {
    //return _performRemoteCallForQueries();
    return _returnTestQueries();
  }

  Future<bool> postNewMedicalInformationEntry(
      MedicalInformation medicalInfo) async {
    print(
        "MedicalInfo (user Id: ${medicalInfo.userId}, title: ${medicalInfo.title}, description: ${medicalInfo.description}, tags: ${medicalInfo.tags}, image: omitted)");
    // return _remotePostNewMedicalInformationEntry(medicalInfo);
    return Future.delayed(const Duration(seconds: 2), () => random.nextBool());
  }

  Future<bool> postSharingPermissions(
      List<SharingPermission> permissions) async {
    // return _remotePostSharingPermissions(permissions);
    return Future.delayed(const Duration(seconds: 1), () => random.nextBool());
  }

  Future<RequestProperties> _retrieveRequestProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return RequestProperties(prefs.getString(API_ADDRESS_KEY),
        prefs.getString(TOKEN_KEY), prefs.getString(USER_ID_KEY));
  }

  Future<List<MedicalInformation>> _returnTestMedicalInfoEntries() {
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

  Future<List<RelevantQueryData>> _returnTestQueries() {
    return Future.delayed(
        delay,
        () => [
              TestDataProvider.testRelevantQueryData1,
              TestDataProvider.testRelevantQueryData2,
              TestDataProvider.testRelevantQueryData3,
              TestDataProvider.testRelevantQueryData4,
            ]);
  }

  Future<List<MedicalInformation>> _performRemoteCallForEntries() async {
    try {
      final requestProperties = await _retrieveRequestProperties();
      print(requestProperties);
      http.Response response = await http.get(
          "${requestProperties.apiAddress}/user/${requestProperties
              .userId}/medicalInformation",
          headers: {
            HttpHeaders.AUTHORIZATION: "Bearer ${requestProperties.apiToken}",
            HttpHeaders.ACCEPT: ContentType.JSON.value
          });
      if (response != null && response.statusCode == 200) {
        Map data = json.decode(response.body);
        print("(MedicalInformation) Response: $data");
        // Parse response to List
        return [];
      }
      return [];
    } on Exception {
      print('Error while retrieving medical information entries!');
      return [];
    }
  }

  Future<List<RelevantQueryData>> _performRemoteCallForQueries() async {
    try {
      final requestProperties = await _retrieveRequestProperties();
      print(requestProperties);
      http.Response response = await http.get(
          "${requestProperties.apiAddress}/user/${requestProperties
              .userId}/medicalQuery/matching",
          headers: {
            HttpHeaders.AUTHORIZATION: "Bearer ${requestProperties.apiToken}",
            HttpHeaders.ACCEPT: ContentType.JSON.value
          });
      if (response != null && response.statusCode == 200) {
        Map data = json.decode(response.body);
        print("(RelevantQueryData) Response: $data");
        // Parse response to List
        return [];
      }
      return [];
    } on Exception {
      print('Error while retrieving relevant medical queries!');
      return [];
    }
  }

  Future<bool> _remotePostNewMedicalInformationEntry(
      MedicalInformation medicalInfo) async {
    try {
      final requestProperties = await _retrieveRequestProperties();
      print(requestProperties);
      http.Response response = await http.post(
          "${requestProperties.apiAddress}/user/${requestProperties
              .userId}/medicalInformation",
          headers: {
            HttpHeaders.AUTHORIZATION: "Bearer ${requestProperties.apiToken}",
            HttpHeaders.CONTENT_TYPE: ContentType.JSON.value,
            HttpHeaders.ACCEPT: ContentType.JSON.value
          },
          body: jsonEncode(medicalInfo.toJson()));
      if (response != null && response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception {
      print('Error while retrieving relevant medical queries!');
      return false;
    }
  }

  Future<bool> _remotePostSharingPermissions(
      List<SharingPermission> permissions) async {
    try {
      final requestProperties = await _retrieveRequestProperties();
      print(requestProperties);
      http.Response response = await http.post(
          "${requestProperties.apiAddress}/user/${requestProperties
              .userId}/medicalQuery/permissions",
          headers: {
            HttpHeaders.AUTHORIZATION: "Bearer ${requestProperties.apiToken}",
            HttpHeaders.CONTENT_TYPE: ContentType.JSON.value,
            HttpHeaders.ACCEPT: ContentType.JSON.value
          },
          body: jsonEncode(permissions));
      if (response != null && response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception {
      print('Error while retrieving relevant medical queries!');
      return false;
    }
  }
}
