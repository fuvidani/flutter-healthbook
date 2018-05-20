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

  @override
  void initState() {
    super.initState();

    Future.wait([
      widget.medicalInfoRepository.loadMedicalInfoEntries(),
      widget.medicalQueryRepository.loadRelevantQueries()
    ]).then((List<List<Object>> results) {
      setState(() {
        appState = AppState(
            medicalInformationEntries: results.first,
            medicalQueries: results.last);
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
          : new Text("Hello"),
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

  void addMedicalInfo(MedicalInformation medicalInfo) {}
}
