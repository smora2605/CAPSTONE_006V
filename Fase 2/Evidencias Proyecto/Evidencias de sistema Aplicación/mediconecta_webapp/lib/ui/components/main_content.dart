import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/logout_dialog.dart';
import 'package:mediconecta_webapp/ui/screens/admin_dashboard.dart';
import 'package:mediconecta_webapp/ui/screens/availabilities_management.dart';
import 'package:mediconecta_webapp/ui/screens/calendar_appointments.dart';
import 'package:mediconecta_webapp/ui/screens/doctors_management.dart';
import 'package:mediconecta_webapp/ui/screens/patients_management.dart';
import 'package:mediconecta_webapp/ui/screens/receptionist_page.dart';
import 'package:mediconecta_webapp/ui/screens/settings_screen.dart';
import 'package:mediconecta_webapp/ui/screens/users_management.dart';
import 'package:mediconecta_webapp/utils/constants.dart';

class MainContent extends StatelessWidget {
  final int selectedIndex;
  final String userRole;

  const MainContent({super.key, required this.selectedIndex, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<int>> roleAccess = Constants().roleAccessArray;

    // Verifica si el rol tiene acceso a la vista seleccionada
    if (!(roleAccess[userRole]?.contains(selectedIndex) ?? false)) {
      return const Center(child: Text('Acceso denegado'));
    }

    switch (selectedIndex) {
      case 0:
        return const ReceptionistPage();
      case 1:
        return const AdminDashboard();
      case 2:
        return const AvailabilitiesManagement();
      case 3:
        return CalendarAppointments();
      case 4:
        return const DoctorsManagement();
      case 5:
        return const PatientsManagement();
      case 6:
        return const UsersManagement();
      case 7:
        return const SettingsScreen();
      case 8:
        return const LogoutDialog();
      default:
        return const AdminDashboard();
    }
  }
}
