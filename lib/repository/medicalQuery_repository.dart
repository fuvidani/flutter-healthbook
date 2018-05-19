import 'dart:async';
import 'package:healthbook/model/models.dart';
import 'package:healthbook/repository/repository.dart';
import 'package:healthbook/web/web_client.dart';

class MedicalQueryRepositoryFlutter implements MedicalQueryRepository {
  final WebClient webClient;

  const MedicalQueryRepositoryFlutter({
    this.webClient = const WebClient(),
  });

  @override
  Future<List<RelevantQueryData>> loadRelevantQueries() {
    return webClient.fetchRelevantQueries();
  }

  @override
  Future<bool> saveSharingPermissions(List<SharingPermission> permissions) {
    return webClient.postSharingPermissions(permissions);
  }
}
