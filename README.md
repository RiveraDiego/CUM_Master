# 🎓 CUM Master

Aplicación Android offline para organizar el historial académico universitario, calcular notas finales y consultar el CUM ponderado por unidades valorativas.

> Estado: desarrollo activo y preparación para pruebas internas/cerradas en Google Play.

## Funcionalidades disponibles

- Gestión local de múltiples estudiantes, con nombre y universidad opcionales y carnet obligatorio.
- CRUD de ciclos lectivos con un único ciclo marcado como actual, o ninguno.
- CRUD de materias asociadas a cualquier ciclo.
- Unidades valorativas y nota final histórica por materia.
- CRUD de evaluaciones con nota manual y ponderación opcional.
- CRUD opcional de actividades dentro de cada evaluación.
- Cálculo jerárquico de actividades, evaluaciones, nota final y CUM.
- Selector global de ciclo por estudiante: Dashboard, materias y creación de materias conservan el mismo contexto.
- Dashboard filtrable por todos los estudiantes o por un estudiante específico.
- Estadísticas históricas con promedio por ciclo, CUM acumulado y tendencia por estudiante.
- Copias de seguridad completas en JSON para guardar, compartir e importar.
- Interfaz en español e inglés.
- Persistencia SQLite completamente local, sin autenticación ni nube.
- Tutorial guiado en el primer inicio, omisible en cualquier paso y accesible nuevamente desde el menú lateral.
- Tema claro, oscuro o sincronizado con la apariencia del dispositivo.
- Menú lateral disponible en todas las pantallas operativas y navegación Atrás basada en el historial real.
- Sistema visual Material 3 unificado e identidad propia de CUM Master.
- Asistente contextual que guía la primera configuración: estudiante, ciclo actual, materia y evaluación.
- Versionado semántico con nombre en clave visible en Configuración (`1.0.0 · Nuegado`).

## Reglas de cálculo implementadas

- Sin ponderaciones, la nota final usa el promedio simple de las evaluaciones.
- Si existen evaluaciones ponderadas y otras sin ponderar, el peso restante se distribuye mediante el promedio de las no ponderadas; nunca se inventa una ponderación individual.
- Una evaluación sin actividades utiliza la nota ingresada manualmente.
- Una evaluación con actividades se calcula cuando sus ponderaciones suman 100 %.
- El CUM general se pondera mediante las unidades valorativas de cada materia.
- El redondeo convencional a un decimal conserva 8.52 como 8.5 y convierte 8.55 en 8.6.

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

## Preparar una versión para Google Play

La aplicación usa el identificador definitivo `com.riveradiego.cum_master`. Google Play no permite cambiarlo después de subir la primera versión.

1. Genera una clave privada de carga con `keytool` o desde Android Studio.
2. Copia `android/key.properties.example` como `android/key.properties`.
3. Completa las contraseñas, alias y ruta del archivo `.jks`.
4. Conserva una copia privada de la clave y sus contraseñas; no pueden recuperarse desde este repositorio.
5. Ejecuta:

```bash
flutter analyze
flutter test
flutter build appbundle --release
```

El archivo para Google Play se generará en `build/app/outputs/bundle/release/app-release.aab`. `key.properties` y todas las claves `.jks`/`.keystore` están excluidos de Git.
La compilación release se detiene intencionalmente si falta la firma, para evitar subir por error un bundle no publicable.

La estación de desarrollo principal ya dispone de una clave de carga privada y genera un AAB firmado verificable. Antes de publicar desde otra computadora, restaura de forma privada `upload-keystore.jks` y `key.properties`; nunca los copies al repositorio.

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
- [x] Refinamiento del sistema visual definitivo
- [x] Ícono definitivo y adaptable de CUM Master
- [x] Nombre, identificador y configuración segura de firma Android
- [x] Generar Android App Bundle firmado para Google Play
- [ ] Pruebas internas y cerradas en Google Play
- [x] Estadísticas históricas
- [ ] Publicidad mínima después de la publicación inicial

El simulador independiente, Premium y la sincronización en la nube están fuera del alcance de la versión inicial.

## Privacidad y datos

CUM Master no requiere una cuenta ni envía información académica a servidores. Los datos viven en el dispositivo y el usuario puede exportar una copia al servicio que prefiera. La versión inicial no incluye publicidad ni SDK publicitarios. Consulta la [política de privacidad](PRIVACY_POLICY.md).

## Autor

Desarrollado por Diego Rivera.
