import 'dart:async';

import 'package:healthbook/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class AppState {
  bool isLoading;
  List<MedicalInformation> medicalInformationEntries;
  List<RelevantQueryData> medicalQueries;
  Map<RelevantQueryData, Map<MedicalInformation, bool>> checkBoxStates;
  Map<RelevantQueryData, List<MedicalInformation>> queriesToMedicalInfoMap;

  AppState({
    this.isLoading = false,
    this.medicalInformationEntries = const [],
    this.medicalQueries = const [],
    this.checkBoxStates = const {},
    this.queriesToMedicalInfoMap = const {},
  });

  AppState.withData(this.medicalInformationEntries, this.medicalQueries) {
    this.isLoading = false;
    this.checkBoxStates = {};
    this.queriesToMedicalInfoMap = {};
    medicalQueries.forEach((query) {
      checkBoxStates[query] = {};
      final List<MedicalInformation> correspondingMedicalEntries = new List();
      query.medicalInfo.forEach((tuple) {
        final String infoId = tuple.item1;
        final MedicalInformation information = medicalInformationEntries
            .singleWhere((element) => element.id == infoId, orElse: () {
          print('No medical information with id $infoId found in the entries!');
          return null;
        });
        correspondingMedicalEntries.add(information);
        checkBoxStates[query][information] = false;
      });
      queriesToMedicalInfoMap[query] = correspondingMedicalEntries;
    });
  }

  factory AppState.loading() => AppState(isLoading: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          medicalInformationEntries == other.medicalInformationEntries &&
          medicalQueries == other.medicalQueries &&
          checkBoxStates == other.checkBoxStates;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      medicalInformationEntries.hashCode ^
      medicalQueries.hashCode ^
      checkBoxStates.hashCode;

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, medicalInformationEntries: $medicalInformationEntries, medicalQueries: $medicalQueries, checkBoxStates: $checkBoxStates}';
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(API_ADDRESS_KEY, null);
    await prefs.setString(TOKEN_KEY, null);
    await prefs.setString(USER_ID_KEY, null);
  }
}

class MedicalInformation {
  String id;
  String userId;
  String title;
  String description;
  String image;
  List<String> tags;

  MedicalInformation(this.id, this.userId, this.title, this.description,
      this.image, this.tags);

  Map<String, dynamic> toJson() => {
        'id': null,
        'userId': userId,
        'title': title,
        'description': description,
        'image': image,
        'tags': tags
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalInformation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          title == other.title &&
          description == other.description &&
          image == other.image &&
          tags == other.tags;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      image.hashCode ^
      tags.hashCode;

  @override
  String toString() {
    return 'MedicalInformation{id: $id, userId: $userId, title: $title, description: $description, image: $image, tags: $tags}';
  }
}

class AuthRequest {
  String email;
  String password;

  AuthRequest(this.email, this.password);

  // TODO change json attribute from username to email for production
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class AuthResponse {
  String token;

  AuthResponse(this.token);

  AuthResponse.fromJson(Map<String, dynamic> json) : token = json['token'];
}

class RelevantQueryData {
  String queryId;
  String queryName;
  String queryDescription;
  String queryInstituteName;
  double queryPrice;
  List<Tuple2> medicalInfo;

  RelevantQueryData(this.queryId, this.queryName, this.queryDescription,
      this.queryInstituteName, this.queryPrice, this.medicalInfo);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelevantQueryData &&
          runtimeType == other.runtimeType &&
          queryId == other.queryId &&
          queryName == other.queryName &&
          queryDescription == other.queryDescription &&
          queryInstituteName == other.queryInstituteName &&
          queryPrice == other.queryPrice &&
          medicalInfo == other.medicalInfo;

  @override
  int get hashCode =>
      queryId.hashCode ^
      queryName.hashCode ^
      queryDescription.hashCode ^
      queryInstituteName.hashCode ^
      queryPrice.hashCode ^
      medicalInfo.hashCode;

  @override
  String toString() {
    return 'RelevantQueryData{queryId: $queryId, queryName: $queryName, queryDescription: $queryDescription, queryInstituteName: $queryInstituteName, queryPrice: $queryPrice, medicalInfo: $medicalInfo}';
  }
}

class SharingPermission {
  String id;
  String information;
  String queryId;

  SharingPermission(this.id, this.information, this.queryId);

  Map<String, dynamic> toJson() => {
        'id': null,
        'information': information,
        'queryId': queryId,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingPermission &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          information == other.information &&
          queryId == other.queryId;

  @override
  int get hashCode => id.hashCode ^ information.hashCode ^ queryId.hashCode;

  @override
  String toString() {
    return 'SharingPermission{id: $id, information: $information, queryId: $queryId}';
  }
}

enum AppTab { MedicalInformationEntries, MedicalQueries }

enum ExtraAction { logout }

class RequestedDataSetValues {
  RelevantQueryData query;
  MedicalInformation medicalInformation;
  bool shared;

  RequestedDataSetValues(this.query, this.medicalInformation, this.shared);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestedDataSetValues &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          medicalInformation == other.medicalInformation &&
          shared == other.shared;

  @override
  int get hashCode =>
      query.hashCode ^ medicalInformation.hashCode ^ shared.hashCode;

  @override
  String toString() {
    return 'RequestedDataSetValues{query: $query, medicalInformation: $medicalInformation, shared: $shared}';
  }
}

class RequestProperties {
  final String apiAddress;
  final String apiToken;
  final String userId;

  RequestProperties(this.apiAddress, this.apiToken, this.userId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestProperties &&
          runtimeType == other.runtimeType &&
          apiAddress == other.apiAddress &&
          apiToken == other.apiToken &&
          userId == other.userId;

  @override
  int get hashCode => apiAddress.hashCode ^ apiToken.hashCode ^ userId.hashCode;

  @override
  String toString() {
    return 'RequestProperties{apiAddress: $apiAddress, apiToken: $apiToken, userId: $userId}';
  }
}
