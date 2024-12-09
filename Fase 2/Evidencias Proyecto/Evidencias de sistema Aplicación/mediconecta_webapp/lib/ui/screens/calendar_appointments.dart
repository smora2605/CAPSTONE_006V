import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:mediconecta_webapp/ui/screens/appointment_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarAppointments extends StatefulWidget {
  @override
  _CalendarAppointmentsState createState() => _CalendarAppointmentsState();
}

class _CalendarAppointmentsState extends State<CalendarAppointments> {
  int? doctorId; // Variable para almacenar el ID del doctor
  bool isLoading = true; // Controlador de carga
  List<Appointment> appointments = []; // Lista de citas

  @override
  void initState() {
    super.initState();
    _initializeDoctor();
  }

  // Función para obtener el ID del doctor si el usuario es un doctor
  Future<void> _initializeDoctor() async {
    try {
      // Obtener el ID del usuario desde el provider
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      int? userId = userAuthProvider.userId;

      if (userId == null) {
        print('No se encontró el ID del usuario. Asegúrate de estar autenticado.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      print('userId: $userId');

      // Llamar a la API para obtener los datos del doctor
      ApiServices apiServices = ApiServices();
      final doctorData = await apiServices.getDoctorByUserId(userId);

      if (doctorData != null && doctorData.containsKey('id')) {
        doctorId = doctorData['id']; // Asignar el ID del doctor
        print('Doctor ID encontrado: $doctorId');

        // Obtener las citas del doctor
        appointments = await getAppointments(doctorId!);
      } else {
        print('No se encontró un doctor para el usuario con ID: $userId');
      }
    } catch (e) {
      print('Error al inicializar el doctor: $e');
    } finally {
      // Asegurarse de que se detenga la carga, ya sea que haya éxito o error
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // Mostrar cargando mientras se obtiene el ID
    }

    return SizedBox(
      height: size.height / 1.2,
      child: SfCalendar(
        view: CalendarView.workWeek, //week or workWeek
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now(),
        dataSource: MeetingDataSource(appointments), // Pasar las citas ya obtenidas
        // Ajustes de la vista de las ranuras de tiempo
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 50, // Ajusta el tamaño de cada bloque de hora
          timeInterval: Duration(minutes: 30),
          startHour: 7,
          endHour: 21,
          timeFormat: 'HH:mm',
        ),
        onTap: (CalendarTapDetails details) {
          // Detecta si se hizo clic en un evento
          if (details.appointments != null && details.appointments!.isNotEmpty) {
            final Appointment selectedAppointment = details.appointments!.first;

            // Navegamos a la vista de detalles
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentDetailsPage(selectedAppointment),
              ),
            );
          }
        },
      ),
    );
  }
}

// Modificar la función para recibir el ID del doctor
Future<List<Appointment>> getAppointments(int doctorId) async {
  List<Appointment> meetings = <Appointment>[];
  final ApiServices apiServices = ApiServices();

  try {
    // Llamada asíncrona para obtener las citas pendientes del doctor
    List<dynamic> appointmentsData = await apiServices.getAppointmentsByDoctor(doctorId);

    print('appointmentsData $appointmentsData');

    // Recorremos los datos y los transformamos en objetos `Appointment`
    for (var appointmentData in appointmentsData) {
      // Parsear la fecha correctamente
      DateTime date = DateTime.parse(appointmentData['fecha']); // Usa solo la fecha sin concatenar

      // Ahora ajustamos la hora manualmente usando la información de la hora
      List<String> timeParts = appointmentData['hora'].split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Ajustar la hora de la fecha
      DateTime startTime = DateTime(date.year, date.month, date.day, hour, minute);

      const Duration eventDuration = Duration(minutes: 15); // Duración fija del evento

      // Crear el objeto Appointment
      meetings.add(Appointment(
        id: {
          'id_cita': appointmentData['id'],
          'id_doctor': doctorId,
          'id_paciente': appointmentData['paciente_id'],
        },
        startTime: startTime,
        endTime: startTime.add(eventDuration),
        subject: appointmentData['paciente_nombre'],  // Nombre del paciente
        notes: appointmentData['motivo'],             // Motivo de la consulta
        color: _getAppointmentColor(appointmentData['estado']),  // Asignar color según el estado
      ));
    }
  } catch (e) {
    print('Error al obtener citas: $e');
  }

  return meetings;
}

// Función auxiliar para obtener un color según el estado de la cita
Color _getAppointmentColor(String estado) {
  switch (estado) {
    case 'Pendiente':
      return Colors.blue;
    case 'No asistió':
      return Colors.red;
    case 'Completada':
      return Colors.red;
    default:
      return Colors.green;
  }
}

// DataSource para las citas
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}