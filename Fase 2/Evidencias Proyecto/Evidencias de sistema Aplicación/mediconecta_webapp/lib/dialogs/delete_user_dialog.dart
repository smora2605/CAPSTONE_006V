// lib/dialogs/delete_user_dialog.dart
import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/models/user_model.dart';

class DeleteUserDialog extends StatelessWidget {
  final User user;
  final VoidCallback onDelete;

  const DeleteUserDialog({
    Key? key,
    required this.user,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar Usuario'),
      content: Text('¿Estás seguro de que quieres eliminar a ${user.name}?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              child: const Text('Eliminar'),
              onPressed: () {
                onDelete();
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
