import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/typedefs.dart';
import 'package:healthbook/widgets/medical_query_item.dart';

class MedicalQueryList extends StatelessWidget {
  final Map<RelevantQueryData, List<MedicalInformation>> queries;
  final bool isLoading;
  final SharingPermissionUpdater sharingPermissionUpdater;
  final RequestedDataSetItemUpdater requestedDataSetItemUpdater;
  final Map<RelevantQueryData, Map<MedicalInformation, bool>> checkBoxStates;

  MedicalQueryList({
    @required this.queries,
    @required this.sharingPermissionUpdater,
    @required this.requestedDataSetItemUpdater,
    @required this.checkBoxStates,
    @required this.isLoading,
  }) : super(key: HealthBookKeys.medicalQueryList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
              key: HealthBookKeys.medicalQueryListLoading,
            ))
          : queries.keys.isEmpty
              ? Center(
                  child: Text(
                      'There are no queries matching yours at the moment.'),
                )
              : ListView.builder(
                  key: HealthBookKeys.medicalQueryList,
                  itemCount: queries.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    final RelevantQueryData query =
                        queries.keys.toList()[index];
                    return MedicalQueryItem(
                      relevantMedicalInfoEntries: queries[query],
                      relevantQueryData: query,
                      checkBoxState: checkBoxStates[query],
                      sharingPermissionUpdater: sharingPermissionUpdater,
                      requestedDataSetItemUpdater: requestedDataSetItemUpdater,
                    );
                  },
                ),
    );
  }
}
