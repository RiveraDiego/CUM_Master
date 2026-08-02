# 🎓 CUM Master

CUM Master es una aplicación Android para organizar calificaciones universitarias, calcular promedios y conocer el Coeficiente de Unidades de Mérito (CUM) sin depender de hojas de cálculo.

Funciona completamente sin conexión a internet. La información académica se guarda en el teléfono del usuario y no requiere crear una cuenta.

## Descargar la aplicación

[**Descargar CUM Master 1.0.0 · Nuegado para Android**](./CUM_Master-1.0.0-Nuegado.apk)

El APK corresponde a una versión release firmada. Como todavía no se distribuye mediante Google Play, Android puede solicitar autorización para instalar aplicaciones desde esta fuente.

## ¿Qué es el CUM?

El CUM es un indicador del rendimiento académico acumulado de un estudiante. A diferencia de un promedio simple, toma en cuenta la nota final de cada materia y sus unidades valorativas (UV): una materia con más UV tiene mayor influencia en el resultado.

La fórmula general utilizada es:

```text
CUM = Σ (nota final de la materia × unidades valorativas) / Σ unidades valorativas
```

La terminología y algunas reglas pueden variar entre universidades. Por eso CUM Master permite personalizar nombres, unidades valorativas predeterminadas, cantidad de decimales y método de redondeo.

## ¿Qué problema resuelve?

Las notas suelen quedar repartidas entre aulas virtuales, mensajes, documentos y cálculos manuales. Esto dificulta saber cuánto se lleva acumulado, qué resultado hace falta en una evaluación o cómo ha cambiado el rendimiento entre ciclos.

CUM Master reúne esa información en una estructura sencilla:

```text
Estudiante → Ciclo → Materia → Evaluación → Actividad opcional
```

La aplicación permite registrar únicamente las notas finales disponibles o añadir más detalle cuando el estudiante lo necesite. Así sirve tanto para reconstruir el historial de ciclos anteriores como para llevar el seguimiento del ciclo actual.

## Funcionalidades

- Administración de uno o varios estudiantes sin autenticación.
- Nombre opcional, número de carnet y universidad para cada estudiante.
- Ciclos académicos históricos y un único ciclo marcado como actual.
- Materias organizadas por estudiante y ciclo lectivo.
- Unidades valorativas y notas finales históricas.
- Evaluaciones con nota manual y ponderación opcional.
- Actividades opcionales dentro de cada evaluación.
- Cálculo automático de evaluaciones, notas finales y CUM acumulado.
- Dashboard filtrable por estudiante y ciclo.
- Estadísticas de promedios por ciclo y evolución académica.
- Indicadores visuales para reconocer el estudiante, ciclo y materia seleccionados.
- Configuración de terminología, UV, decimales y redondeo.
- Tutorial y asistente para completar la configuración inicial.
- Exportación e importación de copias JSON, con opción de guardarlas en una carpeta o compartirlas con otra aplicación.
- Uso exclusivamente vertical para mantener una interfaz consistente en cualquier dispositivo Android.
- Tema claro, oscuro o sincronizado con el dispositivo.
- Interfaz disponible en español e inglés.
- Funcionamiento sin internet, nube ni publicidad en la versión inicial.

## Cómo calcula las notas

- Si ninguna evaluación tiene ponderación, se calcula un promedio simple.
- Si algunas evaluaciones tienen ponderación y otras no, las ponderadas conservan su porcentaje y las restantes forman el promedio correspondiente al porcentaje disponible.
- La aplicación no inventa ponderaciones individuales para evaluaciones que no las tienen.
- Una evaluación sin actividades utiliza la nota ingresada manualmente.
- Si una evaluación tiene actividades, su nota se calcula con las calificaciones y ponderaciones de esas actividades.
- El CUM general pondera la nota final de cada materia según sus unidades valorativas.
- El redondeo convencional conserva `8.52` como `8.5` y convierte `8.55` en `8.6` cuando se utiliza un decimal.

## Privacidad y funcionamiento sin conexión

CUM Master no requiere una cuenta y no envía la información académica a servidores. Los estudiantes, carnets, ciclos, materias y notas permanecen en el dispositivo.

El usuario puede exportar una copia de seguridad y decide dónde guardarla o compartirla. La versión inicial no contiene publicidad ni SDK publicitarios. Consulta la [política de privacidad pública](https://riveradiego.github.io/CUM_Master/) para obtener más información.

## Estado del proyecto

La aplicación se encuentra en desarrollo activo y preparación para pruebas de distribución en Google Play.

### Roadmap

- [x] Estructura base de la aplicación
- [x] Gestión de estudiantes y ciclos
- [x] Gestión de materias, evaluaciones y actividades
- [x] Cálculo de promedios y CUM
- [x] Dashboard y consulta de ciclos históricos
- [x] Estadísticas académicas
- [x] Configuración personalizable
- [x] Copias de seguridad locales
- [x] Tutorial y guía de primera configuración
- [x] Diseño visual, temas e ícono de la aplicación
- [x] Preparación técnica de versiones Android firmadas
- [ ] Pruebas cerradas mediante Google Play
- [ ] Publicación inicial en Google Play
- [ ] Evaluación de publicidad discreta después de la publicación
- [ ] Sincronización opcional en una versión futura

## Tecnología

- Flutter y Dart
- Material 3
- Riverpod
- GoRouter
- SQLite
- Arquitectura organizada por funcionalidades, repositorios y casos de uso

## Ejecutar el proyecto

Se necesita Flutter estable, Android Studio, Android SDK, un JDK compatible y un dispositivo Android o emulador.

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Para generar un APK:

```bash
flutter build apk --release
```

La configuración de firma privada no forma parte del repositorio. El ejemplo disponible en `android/key.properties.example` muestra las propiedades necesarias para preparar una firma propia.

## Calidad y colaboración

Los cambios se integran en la rama `dev` y las versiones estables se fusionan en `main`. El proyecto utiliza análisis estático, pruebas automatizadas y compilaciones Android para validar las funcionalidades.

Las sugerencias, reportes de errores y contribuciones son bienvenidos mediante los issues del repositorio.

## Versión

**1.0.0 · Nuegado**

## Autor y contacto

Desarrollado por **Diego Menendez**

Estudiante de Ingeniería en Sistemas en la Universidad Tecnológica de El Salvador.

- Correo: [dmenendez3075@gmail.com](mailto:dmenendez3075@gmail.com)
- WhatsApp: [+503 7603 7413](https://wa.me/50376037413)

Este proyecto nace como una iniciativa estudiantil para facilitar el seguimiento académico y crear herramientas tecnológicas útiles para la comunidad universitaria.
