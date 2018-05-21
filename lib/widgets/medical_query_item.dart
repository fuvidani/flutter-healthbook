import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/typedefs.dart';
import 'package:healthbook/widgets/requested_data_set_item.dart';
import 'package:healthbook/screens/details_page.dart';

class MedicalQueryItem extends StatelessWidget {
  final List<MedicalInformation> relevantMedicalInfoEntries;
  final RelevantQueryData relevantQueryData;
  final Map<MedicalInformation, bool> checkBoxState;
  final SharingPermissionUpdater sharingPermissionUpdater;
  final RequestedDataSetItemUpdater requestedDataSetItemUpdater;

  MedicalQueryItem(
      {Key key,
      @required this.relevantMedicalInfoEntries,
      @required this.relevantQueryData,
      @required this.checkBoxState,
      @required this.requestedDataSetItemUpdater,
      @required this.sharingPermissionUpdater})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.all(16.0),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _topSection(context),
          _queryDescription(),
          _requestedDataSets(context),
          _bottomButtonSection(),
        ],
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return ListTile(
      trailing: Text('${relevantQueryData.queryPrice}€',
          key: HealthBookKeys.medicalQueryItemPrice(relevantQueryData.queryId),
          style: Theme.of(context).textTheme.headline),
      title: Text(
        relevantQueryData.queryName,
        key: HealthBookKeys.medicalQueryItemTitle(relevantQueryData.queryId),
        style: Theme.of(context).textTheme.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        'by ${relevantQueryData.queryInstituteName}',
        key: HealthBookKeys
            .medicalQueryItemDescription(relevantQueryData.queryId),
        maxLines: 2,
      ),
    );
  }

  Widget _queryDescription() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Text(
        relevantQueryData.queryDescription,
        key: HealthBookKeys
            .medicalQueryItemDescription(relevantQueryData.queryId),
        maxLines: 4,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _requestedDataSets(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        key: HealthBookKeys.requestedDataSetItemList,
        itemCount: relevantMedicalInfoEntries.length,
        itemBuilder: (BuildContext context, int index) {
          final medicalInfo = relevantMedicalInfoEntries[index];
          final requestedDataSetValues = RequestedDataSetValues(
              relevantQueryData, medicalInfo, checkBoxState[medicalInfo]);
          return RequestedDataSetItem(
            requestedDataSetValues: requestedDataSetValues,
            onTap: () => _onDataSetPressed(context, medicalInfo),
            onCheckboxChanged: (shared) {
              requestedDataSetItemUpdater(requestedDataSetValues, shared);
            },
          );
        },
      ),
    );
  }

  Widget _bottomButtonSection() {
    return ButtonTheme.bar(
      child: new ButtonBar(
        children: <Widget>[
          new FlatButton(
            child: const Text('SHARE SELECTED'),
            onPressed: _onSharePressed,
            textColor: Colors.pinkAccent,
          ),
        ],
      ),
    );
  }

  _onDataSetPressed(BuildContext context, MedicalInformation medicalInfo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return MedicalInfoDetailsPage(
            medicalInformation: medicalInfo,
          );
        },
      ),
    );
  }

  void _onSharePressed() {
    List<SharingPermission> permissions = new List();
    checkBoxState.forEach((medicalInfo, shared) {
      if (shared) {
        permissions.add(new SharingPermission(
            null, medicalInfo.id, relevantQueryData.queryId));
      }
    });
    sharingPermissionUpdater(permissions);
  }
}
