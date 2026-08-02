# 🎓 CUM Master

Aplicación Android offline para organizar el historial académico universitario, calcular notas finales y consultar el CUM ponderado por unidades valorativas.

> Estado: desarrollo activo y preparación para pruebas internas/cerradas en Google Play.

## Funcionalidades disponibles

- Gestión local de múltiples estudiantes, diferenciados por carnet y universidad opcional.
- CRUD de ciclos lectivos con un único ciclo marcado como actual, o ninguno.
- CRUD de materias asociadas a cualquier ciclo.
- Unidades valorativas y nota final histórica por materia.
- CRUD de evaluaciones con nota manual y ponderación opcional.
- CRUD opcional de actividades dentro de cada evaluación.
- Cálculo jerárquico de actividades, evaluaciones, nota final y CUM.
- Dashboard con selector de ciclo y acceso rápido al ciclo actual.
- Copias de seguridad completas en JSON para guardar, compartir e importar.
- Interfaz en español e inglés.
- Persistencia SQLite completamente local, sin autenticación ni nube.
- Tutorial guiado en el primer inicio, omisible en cualquier paso y accesible nuevamente desde el menú lateral.
- Tema claro, oscuro o sincronizado con la apariencia del dispositivo.
- Menú lateral disponible en todas las pantallas operativas y navegación Atrás basada en el historial real.

## Reglas de cálculo implementadas

- Sin ponderaciones, la nota final usa el promedio simple de las evaluaciones.
- Si existen evaluaciones ponderadas y otras sin ponderar, el peso restante se distribuye mediante el promedio de las no ponderadas; nunca se inventa una ponderación individual.
- Una evaluación sin actividades utiliza la nota ingresada manualmente.
- Una evaluación con actividades se calcula cuando sus ponderaciones suman 100 %.
- El CUM general se pondera mediante las unidades valorativas de cada materia.

## Tecnología

- Flutter y Dart
- Material 3
- Riverpod
- GoRouter
- SQLite
- Arquitectura Feature First con repositorios y casos de uso
- Internacionalización desde código fuente

## Ejecutar el proyecto

Requisitos:

- Flutter estable configurado
- Android Studio y Android SDK
- JDK compatible con Flutter
- Dispositivo Android o emulador con depuración habilitada

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Para elegir el teléfono desde Android Studio, selecciona el dispositivo Android en la barra superior antes de pulsar **Run**. No selecciones `Windows`, porque el proyecto está configurado actualmente para Android.

## Calidad

El repositorio utiliza Conventional Commits y cada hito funcional se valida con:

- análisis estático;
- pruebas unitarias y de widgets;
- compilación de APK Android;
- instalación y prueba visual en un Galaxy S23 Ultra cuando está conectado.

## Flujo de ramas

- `main`: versión estable que se fusiona cuando un conjunto de cambios está listo.
- `dev`: rama única de desarrollo; todas las funcionalidades se integran aquí mediante commits revisables.

## Roadmap inmediato

- [x] Base Flutter profesional
- [x] CRUD de estudiantes
- [x] CRUD de ciclos
- [x] CRUD de materias
- [x] CRUD de evaluaciones
- [x] CRUD opcional de actividades
- [x] Dashboard académico por ciclo
- [x] CUM ponderado por unidades valorativas
- [x] Exportación e importación local
- [x] Configuración académica: terminología, UV predeterminadas y redondeo
- [x] Tutorial guiado de primer inicio y acceso desde el menú
- [x] Modo claro, oscuro y sincronizado con el dispositivo
- [ ] Refinamiento del sistema visual definitivo
- [ ] Identidad, firma y Android App Bundle para Google Play
- [ ] Pruebas internas y cerradas en Google Play
- [ ] Estadísticas históricas
- [ ] Publicidad mínima

El simulador independiente, Premium y la sincronización en la nube están fuera del alcance de la versión inicial.

## Privacidad y datos

CUM Master no requiere una cuenta ni envía información académica a servidores. Los datos viven en el dispositivo. El usuario puede exportar una copia y guardarla en el servicio que prefiera.

## Autor

Desarrollado por Diego Rivera.
