import 'package:go_router/go_router.dart';

import '../../features/assessments/presentation/pages/assessments_page.dart';
import '../../features/students/presentation/pages/student_form_page.dart';
import '../../features/students/presentation/pages/students_page.dart';
import '../../features/subjects/presentation/pages/subject_form_page.dart';
import '../../features/subjects/presentation/pages/subjects_page.dart';

abstract final class AppRoute {
  static const home = 'home';
  static const studentCreate = 'student-create';
  static const studentEdit = 'student-edit';
  static const subjects = 'subjects';
  static const subjectCreate = 'subject-create';
  static const subjectEdit = 'subject-edit';
  static const assessments = 'assessments';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const StudentsPage(),
      routes: [
        GoRoute(
          path: 'students/new',
          name: AppRoute.studentCreate,
          builder: (context, state) => const StudentFormPage(),
        ),
        GoRoute(
          path: 'students/:studentId/subjects',
          name: AppRoute.subjects,
          builder: (context, state) =>
              SubjectsPage(studentId: state.pathParameters['studentId']!),
          routes: [
            GoRoute(
              path: 'new',
              name: AppRoute.subjectCreate,
              builder: (context, state) => SubjectFormPage(
                studentId: state.pathParameters['studentId']!,
              ),
            ),
            GoRoute(
              path: ':subjectId/edit',
              name: AppRoute.subjectEdit,
              builder: (context, state) => SubjectFormPage(
                studentId: state.pathParameters['studentId']!,
                subjectId: state.pathParameters['subjectId']!,
              ),
            ),
            GoRoute(
              path: ':subjectId/assessments',
              name: AppRoute.assessments,
              builder: (context, state) => AssessmentsPage(
                subjectId: state.pathParameters['subjectId']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: 'students/:studentId/edit',
          name: AppRoute.studentEdit,
          builder: (context, state) =>
              StudentFormPage(studentId: state.pathParameters['studentId']!),
        ),
      ],
    ),
  ],
);
