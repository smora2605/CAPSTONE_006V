import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/ui/screens/admin_dashboard.dart';
import 'package:mediconecta_webapp/ui/screens/appointment_management.dart';
import 'package:mediconecta_webapp/ui/screens/doctors_management.dart';
import 'package:mediconecta_webapp/ui/screens/patients_management.dart';
import 'package:mediconecta_webapp/ui/screens/settings_screen.dart';
import 'package:mediconecta_webapp/ui/screens/users_management.dart';


class MainContent extends StatelessWidget {
  final int selectedIndex;

  const MainContent({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    switch (selectedIndex) {
      case 0:
        return const AdminDashboard();
      case 1:
        return const AppointmentManagement();
      case 2:
        return const SettingsScreen();
      case 3:
        return const DoctorsManagement();
      case 4:
        return const PatientsManagement();
      case 5:
        return const UsersManagement();
      default:
        return const AdminDashboard(); // O una pantalla por defecto
    }
  }
}
