sealed class CycleException implements Exception {
  const CycleException();
}

class DuplicateCycleNameException extends CycleException {
  const DuplicateCycleNameException();
}

class CycleInUseException extends CycleException {
  const CycleInUseException();
}

class CycleStorageException extends CycleException {
  const CycleStorageException();
}
