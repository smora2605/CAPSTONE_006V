import 'package:flutter/material.dart';
import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/widgets/confirm_cita_card.dart';
import 'package:provider/provider.dart';

class PendingAppointments extends StatefulWidget {
  const PendingAppointments({super.key});

  @override
  State<PendingAppointments> createState() => _PendingAppointmentsState();
}

class _PendingAppointmentsState extends State<PendingAppointments> {
  final ApiService apiService = ApiService();
  List<dynamic> appointments = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchAppointmentsPending();
  }

  Future<void> _fetchAppointmentsPending() async {
    try {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final patientId = userAuthProvider.patientId;

      print('patientId$patientId');

      // Llamada para obtener citas pendientes
      final fetchedAppointments = await apiService.fetchAppointmentsPendingByPatient(patientId!);

      setState(() {
        appointments = fetchedAppointments; // Asigna la lista de citas
      });
    } catch (e) {
      print('Error al obtener las citas: $e');
    } finally {
      setState(() {
        isLoading = false; // Finaliza la carga incluso si hay error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Citas pendientes')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: isLoading
                ? const CircularProgressIndicator() // Mostrar spinner si está cargando
                : appointments.isEmpty
                    ? const Text('No tienes citas pendientes') // Mensaje si no hay citas
                    : ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          return ConfirmCitaCard(
                            citaElement: appointments[index],
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
