import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    print('email: $email - pass $password');

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingrese su correo y contraseña.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Llamar al método login del UserAuthProvider
      await Provider.of<UserAuthProvider>(context, listen: false).login(email, password);

      // Navegar a la pantalla principal
      context.go('/');
    } catch (error) {
      setState(() {
        print('error $error');
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
                    width: size.width / 4, // Imagen que ocupa el 30% del ancho disponible
                  ),
                  const SizedBox(height: 40,),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 10),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('Iniciar Sesión'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
