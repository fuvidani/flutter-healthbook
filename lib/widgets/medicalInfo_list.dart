import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/screens/details_page.dart';
import 'package:healthbook/util/keys.dart';
import 'package:healthbook/util/typedefs.dart';
import 'package:healthbook/widgets/medicalInfo_item.dart';

class MedicalInfoList extends StatelessWidget {
  final List<MedicalInformation> medicalInfoList;
  final bool loading;
  final MedicalInfoAdder addInfo;

  MedicalInfoList(
      {@required this.medicalInfoList,
      @required this.loading,
      @required this.addInfo})
      : super(key: HealthBookKeys.medicalInfoList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(
              key: HealthBookKeys.medicalInfoLoading,
            ))
          : ListView.builder(
              key: HealthBookKeys.medicalInfoList,
              itemCount: medicalInfoList.length,
              itemBuilder: (BuildContext context, int index) {
                final medicalInfo = medicalInfoList[index];
                return MedicalInfoItem(
                  medicalInformation: medicalInfo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return MedicalInfoDetailsPage(
                            medicalInformation: medicalInfo,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
