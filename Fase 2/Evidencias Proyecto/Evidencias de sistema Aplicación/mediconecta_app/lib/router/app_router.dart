import 'package:go_router/go_router.dart';
import 'package:mediconecta_app/presentation/screens.dart';
import 'package:mediconecta_app/presentation/screens/auth/login_screen.dart';
import 'package:mediconecta_app/presentation/screens/mainScreen/main_screen.dart';
import 'package:mediconecta_app/presentation/screens/medicalSchedule/medical_schedule.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:provider/provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/assistant',
      name: 'assistant',
      builder: (context, state){
        // Obtiene el usuario actual, asegurándose de que no sea nulo
        final currentUser = state.extra as Map<String, dynamic>?; // Asegúrate de que lo estás casteando correctamente
        return AssistantScreen(currentUser: currentUser!);
      },
    ),
    GoRoute(
      path: '/healthRecord',
      name: 'healthRecord',
      builder: (context, state) => const HealthRecordFormScreen(),
    ),
    GoRoute(
      path: '/pendingAppointments',
      name: 'pendingAppointments',
      builder: (context, state) => const PendingAppointments(),
    ),
    GoRoute(
      path: '/medicalSchedule',
      name: 'medicalSchedule',
      builder: (context, state) => const MedicalSchedule(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    // GoRoute(
    //   path: '/register',
    //   name: 'register',
    //   builder: (context, state) => const RegisterScreen(),
    // ),
    // GoRoute(
    //   path: '/settings',
    //   name: 'settings',
    //   builder: (context, state) => const SettingsScreen(),
    // ),
    // GoRoute(
    //   path: '/detailPage/:id',
    //   name: 'detail',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'] ?? '';
    //     final page = state.extra as PageEntity;
    //     return DetailPage(itemId: id, page: page);
    //   },
    // ),
    // GoRoute(
    //   path: '/detailTask/:id',
    //   name: 'detailTask',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'] ?? '';
    //     final task = state.extra as Task;
    //     return DetailTask(taskId: id, task: task);
    //   },
    // ),
  ],
  redirect: (context, state) {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final isLoggedIn = authProvider.isAuthenticated;

    final uri = state.uri;
    final loggingIn = uri.path == '/login' || uri.path == '/register';

    print('AppRouterCurrentUser isLoggedIn: $isLoggedIn');
    print('authProvider.userId: ${authProvider.userId}');

    // Si el usuario no está autenticado y no está intentando acceder a la página de inicio de sesión o registro, redirigir al inicio de sesión
    if (!isLoggedIn && !loggingIn) return '/login';

    // Si el usuario está autenticado y está en la página de inicio de sesión o registro, redirigir a la página de inicio
    if (isLoggedIn && loggingIn) return '/';

    return null; // Retorna null si no hay redirección
  },
);