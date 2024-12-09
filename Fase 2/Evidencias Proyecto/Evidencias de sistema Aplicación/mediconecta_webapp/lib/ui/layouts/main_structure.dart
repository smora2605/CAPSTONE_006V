import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/ui/components/main_content.dart';
import 'package:mediconecta_webapp/ui/layouts/navbar.dart';
import 'package:mediconecta_webapp/ui/layouts/sidebar.dart';
import 'package:provider/provider.dart';

class MainStructure extends StatefulWidget {
  const MainStructure({super.key});

  @override
  _MainStructureState createState() => _MainStructureState();
}

class _MainStructureState extends State<MainStructure> {
  int _selectedIndex = 0; // Índice del menú seleccionado
  bool isSidebarExpanded = true; // Estado de expansión del Sidebar
  late String userRole; // Rol del usuario

  // Define qué vistas están disponibles para cada rol
  final Map<String, List<int>> roleAccess = {
    'Administrador': [1, 2, 4, 5, 6, 7, 8],
    'Receptionista': [0, 7, 8],
    'Doctor': [3,6, 7, 8],
  };

  @override
  void initState() {
    super.initState();
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
    userRole = userAuthProvider.currentUser?['tipo_usuario'] ?? 'guest'; // Por defecto, rol invitado

    // Ajustar el índice inicial al primer valor permitido según el rol
    final availableIndexes = roleAccess[userRole] ?? [];
    _selectedIndex = availableIndexes.isNotEmpty ? availableIndexes.first : 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado
    });
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarExpanded = !isSidebarExpanded; // Cambia el estado del sidebar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar con ancho fijo y control de expansión
          Sidebar(
            selectedIndex: _selectedIndex,
            isExpanded: isSidebarExpanded,
            onSelectedIndexChanged: _onItemTapped,
            userRole: userRole, // Rol dinámico
          ),

          // Contenedor principal expandido que ocupa el resto del espacio
          Expanded(
            child: Column(
              children: [
                // Navbar en la parte superior
                Navbar(
                  isExpanded: isSidebarExpanded,
                  onMenuPressed: _toggleSidebar,
                ),

                // Contenido principal con soporte para scroll
                Expanded(
                  child: SingleChildScrollView(
                    child: MainContent(
                      selectedIndex: _selectedIndex,
                      userRole: userRole, // Rol dinámico
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}