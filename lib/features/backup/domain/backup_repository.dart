abstract interface class BackupRepository {
  Future<String> exportJson();
  Future<void> importJson(String content);
}
