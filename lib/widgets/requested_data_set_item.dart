import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';

class RequestedDataSetItem extends StatelessWidget {
  final RequestedDataSetValues requestedDataSetValues;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onCheckboxChanged;

  RequestedDataSetItem(
      {Key key,
      @required this.requestedDataSetValues,
      @required this.onTap,
      @required this.onCheckboxChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          key: HealthBookKeys.requestedDataSetItemCheckbox(
              requestedDataSetValues.medicalInformation.id),
          value: requestedDataSetValues.shared,
          onChanged: onCheckboxChanged,
        ),
        title: Text(
          requestedDataSetValues.medicalInformation.title,
          key: HealthBookKeys.requestedDataSetTitle(
              requestedDataSetValues.medicalInformation.id),
          style: Theme.of(context).textTheme.subhead,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
