import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

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
      Navigator.pushReplacementNamed(context, '/home');
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
      body: Row(
        children: [
          // Parte izquierda - Presentación del sistema
          Expanded(
            flex: 2, // 2/3 de la pantalla
            child: Container(
              color: Colors.blueAccent, // Color de fondo
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Aquí puedes agregar una imagen de presentación o logo
                    Image.network(
                      'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
                      width: size.width / 6, // Imagen que ocupa el 30% del ancho disponible
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bienvenido a MediConecta',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'El sistema líder en gestión de citas médicas.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Parte derecha - Formulario de login
          Expanded(
            flex: 3, // 3/5 de la pantalla
            child: Padding(
              padding: const EdgeInsets.all(50.0), // Espacio alrededor del formulario
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Campo de Email
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        // Campo de Contraseña
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 20),
                        // Botón de Inicio de Sesión
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica de inicio de sesión
                              _handleLogin();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Enlace para recuperar contraseña
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Lógica de recuperación de contraseña
                            },
                            child: const Text('¿Olvidaste tu contraseña?'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
