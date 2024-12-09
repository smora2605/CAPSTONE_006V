import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/ui/layouts/main_structure.dart'; // Pantalla principal
import 'package:mediconecta_webapp/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    // Verifica si el usuario está logueado
    if (authProvider.isAuthenticated) {
      return const MainStructure(); // Pantalla principal si está autenticado
    } else {
      return const LoginScreen(); // Pantalla de login si no está autenticado
    }
  }
}
