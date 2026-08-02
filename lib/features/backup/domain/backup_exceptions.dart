sealed class BackupException implements Exception {
  const BackupException();
}

class InvalidBackupException extends BackupException {
  const InvalidBackupException();
}

class BackupStorageException extends BackupException {
  const BackupStorageException();
}
