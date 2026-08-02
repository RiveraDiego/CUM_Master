sealed class AssessmentException implements Exception {
  const AssessmentException();
}

class DuplicateAssessmentNameException extends AssessmentException {
  const DuplicateAssessmentNameException();
}

class AssessmentNotFoundException extends AssessmentException {
  const AssessmentNotFoundException(this.id);
  final String id;
}

class AssessmentStorageException extends AssessmentException {
  const AssessmentStorageException();
}
