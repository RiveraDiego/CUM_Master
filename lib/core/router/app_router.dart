import 'package:go_router/go_router.dart';

import '../../features/assessments/presentation/pages/assessments_page.dart';
import '../../features/cycles/presentation/cycles_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/students/presentation/pages/student_form_page.dart';
import '../../features/students/presentation/pages/students_page.dart';
import '../../features/subjects/presentation/pages/subject_form_page.dart';
import '../../features/subjects/presentation/pages/subjects_page.dart';

abstract final class AppRoute {
  static const dashboard = 'dashboard';
  static const students = 'students';
  static const studentCreate = 'student-create';
  static const studentEdit = 'student-edit';
  static const subjects = 'subjects';
  static const subjectCreate = 'subject-create';
  static const subjectEdit = 'subject-edit';
  static const assessments = 'assessments';
  static const cycles = 'cycles';
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.dashboard,
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/students',
      name: AppRoute.students,
      builder: (context, state) => const StudentsPage(),
      routes: [
        GoRoute(
          path: 'new',
          name: AppRoute.studentCreate,
          builder: (context, state) => const StudentFormPage(),
        ),
        GoRoute(
          path: ':studentId/edit',
          name: AppRoute.studentEdit,
          builder: (context, state) =>
              StudentFormPage(studentId: state.pathParameters['studentId']!),
        ),
        GoRoute(
          path: ':studentId/subjects',
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
          path: ':studentId/cycles',
          name: AppRoute.cycles,
          builder: (context, state) =>
              CyclesPage(studentId: state.pathParameters['studentId']!),
        ),
      ],
    ),
  ],
);
