sealed class SubjectException implements Exception {
  const SubjectException();
}

class DuplicateSubjectNameException extends SubjectException {
  const DuplicateSubjectNameException(this.name);
  final String name;
}

class SubjectNotFoundException extends SubjectException {
  const SubjectNotFoundException(this.id);
  final String id;
}

class SubjectStorageException extends SubjectException {
  const SubjectStorageException();
}
