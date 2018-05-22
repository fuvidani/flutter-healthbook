import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';

class MedicalInfoItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final MedicalInformation medicalInformation;

  MedicalInfoItem(
      {Key key, @required this.onTap, @required this.medicalInformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListTile(
        onTap: onTap,
        title: Hero(
          tag:
              HealthBookKeys.medicalInfoItemTitleHeroTag(medicalInformation.id),
          child: Text(
            medicalInformation.title,
            key: HealthBookKeys.medicalInfoItemTitle(medicalInformation.id),
            style: Theme.of(context).textTheme.title,
          ),
        ),
        subtitle: Text(
          medicalInformation.description,
          key: HealthBookKeys.medicalInfoItemDescription(medicalInformation.id),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      decoration: new BoxDecoration(
          border: new Border(bottom: new BorderSide(color: Colors.grey[300]))),
    );
  }
}
