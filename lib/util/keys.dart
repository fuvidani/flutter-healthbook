import 'package:flutter/widgets.dart';

class HealthBookKeys {
  static final homePage = const Key('__homePage__');
  static final addMedicalInfoFab = const Key('__addMedicalInfoFab__');
  static final snackbar = const Key('__snackbar__');

  static final loginLoading = const Key('__loginLoading__');

  // MedicalInformationEntries
  static final medicalInfoList = const Key('__medicalInfoList__');
  static final medicalInfoLoading = const Key('__medicalInfoLoading__');
  static final medicalInfoItem = (String id) => Key('medicalInfoItem__$id');
  static final medicalInfoItemTitle = (String id) => Key('medicalInfoItem__${id}__Title');
  static final medicalInfoItemDescription = (String id) => Key('medicalInfoItem__${id}__Description');

  // Tabs
  static final tabs = const Key('__tabs__');
  static final medicalInfoTab = const Key('__medicalInfoTab__');
  static final queriesTab = const Key('__queriesTab__');

  // Extra Actions
  static final extraActionsButton = const Key('__extraActionsButton__');
  static final logout = const Key('__logout__');

  // Details Screen
  static final medicalInfoDetailsScreen = const Key('__medicalInfoDetailsScreen__');

  // Add Screen
  static final addMedicalInfoScreen = const Key('__addMedicalInfoScreen__');
  static final saveNewMedicalInfo = const Key('__saveNewMedicalInfo__');
}