import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';
import 'package:mediconecta_webapp/utils/constants.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final bool isExpanded;
  final String userRole;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.isExpanded,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // Define qué vistas están disponibles para cada rol
    final Map<String, List<int>> roleAccess = Constants().roleAccessArray;

    // Obtén las opciones disponibles para el rol actual
    final availableIndexes = roleAccess[userRole] ?? [];

    // Validar que el índice seleccionado sea válido
    final validSelectedIndex = validatedIndex(selectedIndex, availableIndexes);

    // Lista de destinos del Sidebar
    final destinations = const [
      NavigationRailDestination(
        icon: Icon(Icons.app_registration_rounded, color: AppColors.iconColorPrimary),
        label: Text('Recepcionista', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.dashboard, color: AppColors.iconColorPrimary),
        label: Text('Dashboard', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.calendar_month_outlined, color: AppColors.iconColorPrimary),
        label: Text('Asignar disponibilidades', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.calendar_today, color: AppColors.iconColorPrimary),
        label: Text('Citas', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.health_and_safety, color: AppColors.iconColorPrimary),
        label: Text('Doctores', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person_pin_rounded, color: AppColors.iconColorPrimary),
        label: Text('Pacientes', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person, color: AppColors.iconColorPrimary),
        label: Text('Usuarios', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.settings, color: AppColors.iconColorPrimary),
        label: Text('Configuración', style: TextStyle(color: AppColors.textColorPrimary)),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.logout_outlined, color: Colors.black),
        label: Text('Cerrar sesión', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    ];

    // Filtrar destinos según el rol del usuario
    final filteredDestinations = availableIndexes.map((index) => destinations[index]).toList();

    return NavigationRail(
      leading: isExpanded
          ? Row(
              children: [
                Image.network(
                  'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Text(
                  'MediConecta',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            )
          : Image.network(
              'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
              width: 40,
              height: 40,
            ),
      extended: isExpanded,
      backgroundColor: AppColors.secondaryColor,
      selectedIndex: availableIndexes.indexOf(validSelectedIndex),
      onDestinationSelected: (filteredIndex) {
        // Traduce el índice del destino filtrado al índice real
        final realIndex = availableIndexes[filteredIndex];
        onSelectedIndexChanged(realIndex);
      },
      destinations: filteredDestinations,
    );
  }

  // Función para validar el índice seleccionado
  int validatedIndex(int selectedIndex, List<int> availableIndexes) {
    if (availableIndexes.contains(selectedIndex)) {
      return selectedIndex;
    }
    return availableIndexes.isNotEmpty ? availableIndexes.first : 0;
  }
}