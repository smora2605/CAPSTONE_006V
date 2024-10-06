import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onMenuPressed; // Callback para cambiar el estado del sidebar

  const Navbar({
    super.key,
    required this.isExpanded,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: kToolbarHeight, // Usar la altura estándar de la AppBar
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 198, 198, 198), width: 1.0), // Borde gris en la parte inferior
        ),
      ),
      // color: AppColors.secondaryColor, // Color de fondo del Navbar
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(isExpanded ? Icons.close : Icons.menu), // Cambia el icono según el estado
              onPressed: onMenuPressed, // Llama al callback del widget padre para cambiar el estado
            ),
            const Spacer(), // Para separar los elementos
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Lógica de búsqueda
              },
            ),
            const CircleAvatar(
              backgroundImage: NetworkImage('url-de-la-foto-del-usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
