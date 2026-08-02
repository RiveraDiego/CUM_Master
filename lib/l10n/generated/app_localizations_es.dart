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

  @override
  String get subjectsTitle => 'Materias';

  @override
  String get subjectsCreateAction => 'Agregar materia';

  @override
  String get subjectsEmptyDescription =>
      'Este estudiante aún no tiene materias. Agrega la primera para comenzar a organizar sus notas.';

  @override
  String get subjectsLoadError => 'No se pudieron cargar las materias.';

  @override
  String get subjectCreateTitle => 'Agregar materia';

  @override
  String get subjectEditTitle => 'Editar materia';

  @override
  String get subjectNameLabel => 'Nombre de la materia';

  @override
  String get subjectNameRequiredError =>
      'El nombre de la materia es obligatorio.';

  @override
  String get subjectCodeLabel => 'Código (opcional)';

  @override
  String get subjectCodeNotSpecified => 'Sin código';

  @override
  String get subjectDuplicateError =>
      'Ya existe una materia con este nombre para el estudiante.';

  @override
  String get subjectMoreActions => 'Más acciones de la materia';

  @override
  String get subjectDeleteTitle => '¿Eliminar materia?';

  @override
  String subjectDeleteMessage(String subjectName) {
    return 'Se eliminará permanentemente la materia $subjectName.';
  }

  @override
  String get subjectDeleted => 'Materia eliminada.';

  @override
  String get subjectNotFoundError => 'Esta materia ya no existe.';

  @override
  String get subjectStorageError =>
      'No se pudieron guardar los datos de la materia. Inténtalo de nuevo.';

  @override
  String get assessmentsTitle => 'Evaluaciones y notas';

  @override
  String get assessmentsCreateAction => 'Agregar evaluación';

  @override
  String get assessmentsEmptyDescription =>
      'Esta materia aún no tiene evaluaciones. Agrega la primera nota.';

  @override
  String get assessmentsLoadError => 'No se pudieron cargar las evaluaciones.';

  @override
  String get assessmentCreateTitle => 'Agregar evaluación';

  @override
  String get assessmentEditTitle => 'Editar evaluación';

  @override
  String get assessmentNameLabel => 'Nombre de la evaluación';

  @override
  String get assessmentNameRequiredError => 'El nombre es obligatorio.';

  @override
  String get assessmentScoreLabel => 'Nota obtenida';

  @override
  String get assessmentMaxScoreLabel => 'Nota máxima';

  @override
  String get assessmentWeightLabel => 'Ponderación % (opcional)';

  @override
  String get assessmentNumberError =>
      'Ingresa un número igual o mayor que cero.';

  @override
  String get assessmentPositiveError => 'Ingresa un número mayor que cero.';

  @override
  String get assessmentScoreRangeError =>
      'La nota obtenida no puede superar la nota máxima.';

  @override
  String get assessmentWeightError =>
      'La ponderación debe estar entre 0 y 100.';

  @override
  String get assessmentDuplicateError =>
      'Ya existe una evaluación con este nombre.';

  @override
  String get assessmentStorageError =>
      'No se pudieron guardar los datos de la evaluación.';

  @override
  String get assessmentDeleteTitle => '¿Eliminar evaluación?';

  @override
  String assessmentDeleteMessage(String assessmentName) {
    return 'Se eliminará permanentemente $assessmentName.';
  }

  @override
  String assessmentScore(num score, num maxScore) {
    return '$score de $maxScore';
  }

  @override
  String get dashboardTitle => 'Inicio';

  @override
  String get activeCycleTitle => 'Ciclo activo';

  @override
  String get activeCycleCurrentScope =>
      'Resumen de las materias del ciclo lectivo activo de cada estudiante.';

  @override
  String get dashboardLoadError => 'No se pudo cargar el resumen académico.';

  @override
  String get dashboardNoStudents =>
      'Agrega un estudiante para ver su resumen académico.';

  @override
  String get dashboardNoSubjects => 'Este estudiante aún no tiene materias.';

  @override
  String get dashboardNoGrades => 'Sin evaluaciones registradas';

  @override
  String get dashboardWeightedAverage => 'Promedio ponderado';

  @override
  String get dashboardSimpleAverage => 'Promedio simple';

  @override
  String get dashboardManageSubjects => 'Gestionar materias';

  @override
  String get dashboardNoActiveCycle => 'Sin ciclo activo';

  @override
  String get cyclesTitle => 'Ciclos lectivos';

  @override
  String get cyclesCreateAction => 'Agregar ciclo';

  @override
  String get cyclesEmpty =>
      'Aún no hay ciclos. Agrega uno para organizar las materias.';

  @override
  String get cyclesLoadError => 'No se pudieron cargar los ciclos.';

  @override
  String get cycleCreateTitle => 'Agregar ciclo lectivo';

  @override
  String get cycleNameLabel => 'Nombre del ciclo';

  @override
  String get cycleActive => 'Ciclo activo';

  @override
  String get cycleDuplicateError => 'Ya existe un ciclo con este nombre.';

  @override
  String get cycleInUseError =>
      'No se puede eliminar un ciclo que tiene materias.';

  @override
  String get cycleStorageError => 'No se pudieron guardar los datos del ciclo.';

  @override
  String get subjectCycleLabel => 'Ciclo lectivo';

  @override
  String get subjectCycleRequiredError =>
      'Selecciona el ciclo al que pertenece la materia.';

  @override
  String get subjectCreditUnitsLabel => 'Unidades valorativas (UV)';

  @override
  String get subjectCreditUnitsError =>
      'Ingresa una cantidad de UV mayor que cero.';

  @override
  String get subjectHistoricalGradeLabel => 'Nota final histórica (opcional)';

  @override
  String get subjectHistoricalGradeHelp =>
      'Si la completas, tendrá prioridad sobre el cálculo de evaluaciones.';

  @override
  String get subjectHistoricalGradeError => 'La nota debe estar entre 0 y 10.';

  @override
  String get activitiesTitle => 'Actividades';

  @override
  String get activitiesCreateAction => 'Agregar actividad';

  @override
  String get activitiesEmpty =>
      'No hay actividades. Se utilizará la nota manual de la evaluación.';

  @override
  String get activitiesLoadError => 'No se pudieron cargar las actividades.';

  @override
  String get activityCreateTitle => 'Agregar actividad';

  @override
  String get activityEditTitle => 'Editar actividad';

  @override
  String get activityNameLabel => 'Nombre de la actividad';

  @override
  String get activityRequiredError => 'El nombre es obligatorio.';

  @override
  String activityWeightTotal(num weight) {
    return 'Ponderación total: $weight%';
  }

  @override
  String get activityCalculationReady =>
      'La nota de la evaluación se calculará con estas actividades.';

  @override
  String get activityCalculationIncomplete =>
      'Completa exactamente 100% para calcular la evaluación.';

  @override
  String get cycleEditTitle => 'Renombrar ciclo';

  @override
  String get cyclesManageAction => 'Gestionar ciclos';

  @override
  String get cycleCreateInlineAction => 'Crear nuevo ciclo';

  @override
  String get subjectsCycleFilterLabel => 'Ciclo que deseas consultar';

  @override
  String get subjectsEmptyForCycle => 'Este ciclo aún no tiene materias.';

  @override
  String get cycleActivateAction => 'Marcar como ciclo activo';

  @override
  String get cycleRenameAction => 'Renombrar';

  @override
  String get cycleCurrentState => 'Este es el ciclo actual';

  @override
  String get cycleNotCurrentState => 'No es el ciclo actual';

  @override
  String get dashboardNoCurrentCycleMessage =>
      'No has establecido ningún ciclo como actual. Activa uno para ver sus materias y notas aquí.';

  @override
  String get dashboardChooseCurrentCycle => 'Elegir ciclo actual';

  @override
  String get assessmentManualGrade => 'Nota manual (sin actividades)';

  @override
  String get assessmentCalculatedGrade => 'Nota calculada por actividades';

  @override
  String dashboardGeneralCum(String cum) {
    return 'CUM general histórico: $cum';
  }
}
