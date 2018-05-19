import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';

class MedicalInfoItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final MedicalInformation medicalInformation;

  MedicalInfoItem({
    Key key,
    @required this.onTap,
    @required this.medicalInformation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        medicalInformation.title,
        key: HealthBookKeys.medicalInfoItemTitle(medicalInformation.id),
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(
        medicalInformation.description,
        key: HealthBookKeys.medicalInfoItemDescription(medicalInformation.id),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
      ),
    );
  }

}