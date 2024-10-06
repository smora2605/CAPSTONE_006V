import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/ui/components/main_content.dart';
import 'package:mediconecta_webapp/ui/layouts/navbar.dart';
import 'package:mediconecta_webapp/ui/layouts/sidebar.dart';

class MainStructure extends StatefulWidget {
  const MainStructure({super.key});

  @override
  _MainStructureState createState() => _MainStructureState();
}

class _MainStructureState extends State<MainStructure> {
  int _selectedIndex = 0; // Índice del menú seleccionado
  bool isSidebarExpanded = true; // Estado de expansión del Sidebar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Actualiza el índice seleccionado
    });
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarExpanded = !isSidebarExpanded; // Cambia el estado del sidebar (expandido o contraído)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            isExpanded: isSidebarExpanded, // El sidebar sabe si debe estar expandido o contraído
            onSelectedIndexChanged: _onItemTapped, // Maneja la selección del menú
          ),
          Expanded(
            child: Column(
              children: [
                Navbar(
                  isExpanded: isSidebarExpanded, // Pasa el estado actual del sidebar al Navbar
                  onMenuPressed: _toggleSidebar, // Callback para manejar la acción del botón de menú
                ),
                  MainContent(selectedIndex: _selectedIndex), // Contenido dinámico
              ],
            )
          ), 
          ]    
        )
    );
  }
}
