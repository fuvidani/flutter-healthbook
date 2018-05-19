import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/routes.dart';
import 'package:healthbook/widgets/extra_actions_button.dart';

class HomePage extends StatefulWidget {
  final String title;
  final AppState appState;

  HomePage({
    Key key,
    @required this.title,
    @required this.appState
  }) : super(key: HealthBookKeys.homePage);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _newMedicalInformation() {

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: false,
        actions: [
          ExtraActionsButton(
            logout:false,
            onSelected: (action) {
              if (action == ExtraAction.logout) {
                widget.appState.logout().then((_) {
                  Navigator.pushNamedAndRemoveUntil(context, HealthBookRoutes.login, (_) => false);
                });
              }
            },
          )
        ],
      ),
      body: new Text("Home"),
      floatingActionButton: new FloatingActionButton(
        key: HealthBookKeys.addMedicalInfoFab,
        onPressed: _newMedicalInformation,
        tooltip: 'Add new medical information',
        child: new Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

}