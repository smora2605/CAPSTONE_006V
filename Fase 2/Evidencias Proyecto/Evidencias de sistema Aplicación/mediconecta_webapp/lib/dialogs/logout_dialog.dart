// lib/dialogs/delete_user_dialog.dart
import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class LogoutDialog extends StatelessWidget {

  const LogoutDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    
    return AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de querer cerrar sesión?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              child: const Text('Cerrar sesión'),
              onPressed: () {
                authProvider.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
