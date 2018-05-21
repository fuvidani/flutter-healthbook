import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/repository/repository.dart';
import 'package:healthbook/screens/add_page.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/routes.dart';
import 'package:healthbook/widgets/extra_actions_button.dart';
import 'package:healthbook/widgets/medicalInfo_list.dart';
import 'package:healthbook/widgets/medical_query_list.dart';

class HomePage extends StatefulWidget {
  final String title;
  final MedicalInfoRepository medicalInfoRepository;
  final MedicalQueryRepository medicalQueryRepository;

  HomePage(
      {Key key,
      @required this.title,
      @required this.medicalInfoRepository,
      @required this.medicalQueryRepository})
      : super(key: HealthBookKeys.homePage);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState appState = AppState.loading();
  AppTab activeTab = AppTab.MedicalInformationEntries;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  _loadLists() {
    Future.wait([
      widget.medicalInfoRepository.loadMedicalInfoEntries(),
      widget.medicalQueryRepository.loadRelevantQueries()
    ]).then((List<List<Object>> results) {
      setState(() {
        appState = AppState.withData(results.first, results.last);
      });
    }).catchError((e) {
      print(e);
      setState(() {
        appState.isLoading = false;
      });
    });
  }

  _updateTab(AppTab tab) {
    setState(() {
      activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: [
          ExtraActionsButton(
            logout: false,
            onSelected: (action) {
              if (action == ExtraAction.logout) {
                appState.logout().then((_) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HealthBookRoutes.login, (_) => false);
                });
              }
            },
          )
        ],
      ),
      body: activeTab == AppTab.MedicalInformationEntries
          ? MedicalInfoList(
              medicalInfoList: appState.medicalInformationEntries,
              loading: appState.isLoading,
              addInfo: addMedicalInfo,
            )
          : MedicalQueryList(
              queries: appState.queriesToMedicalInfoMap,
              sharingPermissionUpdater: updateSharingPermission,
              requestedDataSetItemUpdater: requestedDataSetCheckBoxUpdate,
              checkBoxStates: appState.checkBoxStates,
              isLoading: appState.isLoading,
            ),
      floatingActionButton: activeTab == AppTab.MedicalInformationEntries
          ? new FloatingActionButton(
              key: HealthBookKeys.addMedicalInfoFab,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new AddMedicalInfoPage(
                              infoAdder: addMedicalInfo,
                            )));
              },
              tooltip: 'Add new medical information',
              child: new Icon(Icons.add),
              backgroundColor: Colors.pinkAccent,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        key: HealthBookKeys.tabs,
        currentIndex: AppTab.values.indexOf(activeTab),
        onTap: (index) {
          _updateTab(AppTab.values[index]);
        },
        items: AppTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Icon(
              tab == AppTab.MedicalInformationEntries
                  ? Icons.list
                  : Icons.share,
              key: tab == AppTab.MedicalQueries
                  ? HealthBookKeys.queriesTab
                  : HealthBookKeys.medicalInfoTab,
            ),
            title: Text(
              tab == AppTab.MedicalInformationEntries
                  ? "My entries"
                  : "Medical queries",
            ),
          );
        }).toList(),
      ),
    );
  }

  void _reloadEverything() {
    setState(() {
      appState.isLoading = true;
    });
    _loadLists();
  }

  Future<bool> addMedicalInfo(MedicalInformation medicalInfo) {
    return widget.medicalInfoRepository
        .saveMedicalInformation(medicalInfo)
        .then((bool success) {
      if (success) {
        setState(() {
          appState.isLoading = true;
        });
        _loadLists();
      }
      return success;
    });
  }

  Future<bool> updateSharingPermission(List<SharingPermission> permissions) {
    if (permissions.isNotEmpty) {
      return widget.medicalQueryRepository
          .saveSharingPermissions(permissions)
          .then((bool isSuccess) {
        final String snackBarMessage = isSuccess
            ? "Selected entries successfully shared!"
            : "Sharing unsuccessful. Please try again.";
        final snackBar = new SnackBar(
          content: new Text(snackBarMessage),
          duration: Duration(seconds: 3),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        if (isSuccess) {
          _reloadEverything();
        }
      });
    }
    final snackBar = new SnackBar(
      content: new Text('No entry selected'),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return Future.value(true);
  }

  void requestedDataSetCheckBoxUpdate(
      RequestedDataSetValues values, bool shared) {
    setState(() {
      appState.checkBoxStates[values.query][values.medicalInformation] = shared;
    });
  }
}
