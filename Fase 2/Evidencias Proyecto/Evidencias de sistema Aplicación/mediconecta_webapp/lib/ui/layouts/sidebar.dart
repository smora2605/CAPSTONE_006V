import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectedIndexChanged;
  final bool isExpanded; // Estado del Sidebar (expandido o contraído)

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onSelectedIndexChanged,
    required this.isExpanded, // Recibe el estado de expansión
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: isExpanded ? Row(
        children: [
          Image.network(
            'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 10,),
          const Text(
            'MediConecta',
            style: TextStyle(
              fontSize: 18
            ),
          ),
        ],
      )
          : Image.network(
              'https://images.vexels.com/content/142777/preview/heartbeat-star-medical-logo-b60fbc.png',
              width: 40,
              height: 40,
            ),
      extended: isExpanded, // Expande o contrae el menú basado en el estado
      backgroundColor: AppColors.secondaryColor,
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelectedIndexChanged,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard, color: AppColors.iconColorPrimary,),
          label: Text('Dashboard', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today, color: AppColors.iconColorPrimary,),
          label: Text('Citas', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings, color: AppColors.iconColorPrimary,),
          label: Text('Configuración', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.health_and_safety, color: AppColors.iconColorPrimary,),
          label: Text('Doctores', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_pin_rounded, color: AppColors.iconColorPrimary,),
          label: Text('Pacientes', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person, color: AppColors.iconColorPrimary,),
          label: Text('Usuarios', style: TextStyle(color: AppColors.textColorPrimary),),
        ),
      ],
    );
  }
}
