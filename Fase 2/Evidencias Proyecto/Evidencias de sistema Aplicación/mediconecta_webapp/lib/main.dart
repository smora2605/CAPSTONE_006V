import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Para localización
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/router/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserAuthProvider()..tryAutoLogin()),
      ],
      child: const MaterialApp(
        // Establece el idioma a español
        locale: Locale('es', ''), // 'es' para español
        supportedLocales: [
          Locale('es', ''), // Añadir español
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Medical Appointment System',
        debugShowCheckedModeBanner: false,
        home: AppRouter(), // Cambia según la lógica de autenticación
      ),
    );
  }
}
