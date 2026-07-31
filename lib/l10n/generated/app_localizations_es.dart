// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'CUM Master';

  @override
  String get studentsEmptyTitle => 'Aún no hay estudiantes';

  @override
  String get studentsEmptyDescription =>
      'Crea un perfil de estudiante para organizar la información académica en este dispositivo.';

  @override
  String get studentsCreateAction => 'Agregar estudiante';

  @override
  String get studentsTitle => 'Estudiantes';

  @override
  String get studentCreateTitle => 'Agregar estudiante';

  @override
  String get studentEditTitle => 'Editar estudiante';

  @override
  String get studentCardLabel => 'Carnet estudiantil';

  @override
  String get studentCardHint => 'Ingresa el número de carnet';

  @override
  String get studentCardRequiredError =>
      'El carnet estudiantil es obligatorio.';

  @override
  String get studentCardDuplicateError =>
      'Ya existe un estudiante con este carnet.';

  @override
  String get studentUniversityLabel => 'Universidad (opcional)';

  @override
  String get studentUniversityHint => 'Ingresa el nombre de la universidad';

  @override
  String get studentUniversityNotSpecified => 'Universidad no especificada';

  @override
  String get studentMoreActions => 'Más acciones del estudiante';

  @override
  String get studentDeleteTitle => '¿Eliminar estudiante?';

  @override
  String studentDeleteMessage(String studentCard) {
    return 'Se eliminará permanentemente al estudiante $studentCard.';
  }

  @override
  String get studentDeleted => 'Estudiante eliminado.';

  @override
  String get studentNotFoundError => 'Este estudiante ya no existe.';

  @override
  String get studentStorageError =>
      'No se pudieron guardar los datos. Inténtalo de nuevo.';

  @override
  String get studentsLoadError => 'No se pudieron cargar los estudiantes.';

  @override
  String get saveAction => 'Guardar';

  @override
  String get editAction => 'Editar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get cancelAction => 'Cancelar';

  @override
  String get closeAction => 'Cerrar';

  @override
  String get retryAction => 'Reintentar';
}
