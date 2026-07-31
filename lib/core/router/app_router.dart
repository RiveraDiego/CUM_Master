import 'package:go_router/go_router.dart';

import '../../features/students/presentation/pages/student_form_page.dart';
import '../../features/students/presentation/pages/students_page.dart';

abstract final class AppRoute {
  static const home = 'home';
  static const studentCreate = 'student-create';
  static const studentEdit = 'student-edit';
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
          path: 'students/:studentId/edit',
          name: AppRoute.studentEdit,
          builder: (context, state) =>
              StudentFormPage(studentId: state.pathParameters['studentId']!),
        ),
      ],
    ),
  ],
);
