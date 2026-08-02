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
  String get drawerTagline => 'Tu progreso académico';

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
  String get studentNameLabel => 'Nombre del estudiante';

  @override
  String get studentNameHint => 'Ej. Diego, Ana o Mi cuenta';

  @override
  String get optionalFieldLabel => 'Opcional';

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
  String get dashboardStudentFilterLabel => 'Filtrar por estudiante';

  @override
  String get dashboardAllStudents => 'Todos los estudiantes';

  @override
  String get statisticsTitle => 'Estadísticas';

  @override
  String get statisticsLoadError => 'No se pudieron calcular las estadísticas.';

  @override
  String get statisticsNoStudents =>
      'Agrega un estudiante para comenzar a construir su historial académico.';

  @override
  String get statisticsNoCycles =>
      'Este estudiante todavía no tiene ciclos registrados.';

  @override
  String get statisticsEvolutionTitle => 'Evolución del promedio por ciclo';

  @override
  String statisticsCycleSubjects(int graded, int total) {
    return '$graded de $total materias con nota';
  }

  @override
  String statisticsAverageValue(String value) {
    return 'Prom. $value';
  }

  @override
  String statisticsCumValue(String value) {
    return 'CUM $value';
  }

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
  String get backupTitle => 'Copia de seguridad';

  @override
  String get backupExportTitle => 'Exportar todos mis datos';

  @override
  String get backupExportDescription =>
      'Crea un archivo para guardarlo o compartirlo.';

  @override
  String get backupImportTitle => 'Importar una copia';

  @override
  String get backupImportDescription =>
      'Restaura estudiantes, ciclos, materias y notas desde un archivo.';

  @override
  String get backupImportConfirmTitle => '¿Importar una copia?';

  @override
  String get backupImportConfirmMessage =>
      'Los datos actuales del dispositivo serán reemplazados. Esta acción no se puede deshacer.';

  @override
  String get backupChooseFileAction => 'Elegir archivo';

  @override
  String get backupImportSuccess => 'La copia se importó correctamente.';

  @override
  String get backupInvalidFileError =>
      'El archivo no es una copia válida de CUM Master.';

  @override
  String get backupImportError => 'No se pudo importar la copia.';

  @override
  String get backupExportError => 'No se pudo crear la copia de seguridad.';

  @override
  String get dashboardCycleSelectorLabel => 'Ciclo mostrado';

  @override
  String get dashboardCurrentCycleShort => 'Actual';

  @override
  String get dashboardShowCurrentCycle => 'Ver actual';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsThemeLabel => 'Tema de la aplicación';

  @override
  String get settingsThemeHelp =>
      'Puedes seguir la apariencia del teléfono o elegir un tema fijo.';

  @override
  String get settingsThemeSystem => 'Usar tema del dispositivo';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLoadError => 'No se pudo cargar la configuración.';

  @override
  String get settingsCalculationTitle => 'Cálculo y valores predeterminados';

  @override
  String get settingsDefaultUvLabel => 'UV predeterminadas';

  @override
  String get settingsDefaultUvHelp => 'Se usarán al crear una materia nueva.';

  @override
  String get settingsDecimalsLabel => 'Decimales mostrados';

  @override
  String settingsDecimalsValue(int count) {
    return '$count decimales';
  }

  @override
  String get settingsRoundingLabel => 'Método de redondeo';

  @override
  String get settingsRoundingCeiling => 'Hacia arriba';

  @override
  String get settingsRoundingNearest => 'Al valor más cercano';

  @override
  String get settingsRoundingFloor => 'Hacia abajo';

  @override
  String get settingsApplyUvAction => 'Aplicar estas UV a materias existentes';

  @override
  String get settingsApplyUvTitle => '¿Actualizar todas las materias?';

  @override
  String settingsApplyUvMessage(String value) {
    return 'Todas las materias usarán $value UV. Las notas no cambiarán.';
  }

  @override
  String get settingsApplyAction => 'Aplicar';

  @override
  String get settingsUvApplied => 'Las UV se actualizaron correctamente.';

  @override
  String get settingsTerminologyTitle => 'Terminología';

  @override
  String get settingsTerminologyHelp =>
      'Déjalo vacío para usar los nombres predeterminados del idioma.';

  @override
  String get settingsCycleTerm => 'Ciclo';

  @override
  String get settingsSubjectTerm => 'Materia';

  @override
  String get settingsAssessmentTerm => 'Evaluación';

  @override
  String get settingsActivityTerm => 'Actividad';

  @override
  String get settingsSingularLabel => 'singular';

  @override
  String get settingsPluralLabel => 'plural';

  @override
  String get settingsSaved => 'Configuración guardada.';

  @override
  String get tutorialTitle => 'Cómo usar CUM Master';

  @override
  String get tutorialMenuAction => 'Ver tutorial';

  @override
  String get tutorialSkipAction => 'Saltar';

  @override
  String get tutorialPreviousAction => 'Anterior';

  @override
  String get tutorialNextAction => 'Siguiente';

  @override
  String get tutorialFinishAction => 'Comenzar';

  @override
  String tutorialStepPosition(int current, int total) {
    return 'Paso $current de $total';
  }

  @override
  String get tutorialWelcomeTitle => 'Tu historial académico, en un solo lugar';

  @override
  String get tutorialWelcomeDescription =>
      'CUM Master funciona sin cuenta y guarda todo en este dispositivo. Organiza tus ciclos, materias y notas con la estructura que utiliza tu universidad.';

  @override
  String get tutorialStudentsTitle => 'Empieza por el estudiante';

  @override
  String get tutorialStudentsDescription =>
      'Crea un estudiante usando su número de carnet y, opcionalmente, su universidad. Puedes administrar varios estudiantes sin autenticación.';

  @override
  String get tutorialCyclesTitle => 'Organiza las materias por ciclo';

  @override
  String get tutorialCyclesDescription =>
      'Crea tus ciclos históricos y marca como actual únicamente el que estás cursando. Luego agrega cada materia al ciclo que le corresponde y asigna sus UV.';

  @override
  String get tutorialGradesTitle => 'Registra solo el detalle que necesites';

  @override
  String get tutorialGradesDescription =>
      'Puedes escribir directamente la nota de cada evaluación. Si deseas mayor precisión, agrega sus actividades y ponderaciones; la evaluación se calculará cuando completen el 100 %.';

  @override
  String get tutorialDashboardTitle => 'Consulta promedios y CUM';

  @override
  String get tutorialDashboardDescription =>
      'El dashboard muestra las materias del ciclo elegido. Puedes consultar ciclos históricos, volver al ciclo actual y revisar el CUM general ponderado por UV.';

  @override
  String get tutorialBackupTitle => 'Configura y protege tus datos';

  @override
  String get tutorialBackupDescription =>
      'En Configuración académica puedes ajustar UV, decimales, redondeo y terminología. Exporta copias periódicas para restaurarlas en otro teléfono cuando lo necesites.';

  @override
  String get assessmentManualGrade => 'Nota manual (sin actividades)';

  @override
  String get assessmentCalculatedGrade => 'Nota calculada por actividades';

  @override
  String dashboardGeneralCum(String cum) {
    return 'CUM general histórico: $cum';
  }

  @override
  String get settingsAdPrivacyAction => 'Opciones de privacidad de anuncios';

  @override
  String get settingsAdPrivacyError =>
      'No se pudieron abrir las opciones de privacidad. IntÃ©ntalo nuevamente.';
}
