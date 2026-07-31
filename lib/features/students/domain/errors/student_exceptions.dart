sealed class StudentException implements Exception {
  const StudentException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class DuplicateStudentCardException extends StudentException {
  const DuplicateStudentCardException(this.studentCard)
    : super('A student with this card already exists.');

  final String studentCard;
}

final class StudentNotFoundException extends StudentException {
  const StudentNotFoundException(this.studentId)
    : super('The requested student does not exist.');

  final String studentId;
}

final class StudentStorageException extends StudentException {
  const StudentStorageException()
    : super('The student data could not be stored.');
}
