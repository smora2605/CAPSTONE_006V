import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/add_user_dialog.dart';
import 'package:mediconecta_webapp/dialogs/appointment_patient/add_appointment_patient_dialog.dart';
import 'package:mediconecta_webapp/dialogs/patientsDialogs/add_patient.dialog.dart';
import 'package:mediconecta_webapp/ui/components/card_chart_admin_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReceptionistPage extends StatefulWidget {
  const ReceptionistPage({super.key});

  @override
  _ReceptionistPageState createState() => _ReceptionistPageState();
}

class _ReceptionistPageState extends State<ReceptionistPage> {

  // Controla qué tabla mostrar (true para doctores, false para pacientes críticos)
  bool isShowingDoctors = true;

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => const AddUserDialog(),
    );
  }

  void _addPatient() {
    showDialog(
      context: context,
      builder: (context) => const AddPatientDialog(),
    );
  }

  void _addAppointmentPatient() {
    showDialog(
      context: context,
      builder: (context) => const AddAppointmentPatientDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Tarjetas de resumen
          const Row(
            children: [
              Expanded(
                child: CardChartAdminWidget(
                  title: 'Pacientes registrados',
                  desc: 'Total pacientes registrados',
                  count: 150,
                  icon: Icon(Icons.person),
                  chart: 'bar',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CardChartAdminWidget(
                  title: 'Citas programadas',
                  desc: 'Citas de la semana',
                  count: 45,
                  icon: Icon(Icons.calendar_month),
                  chart: 'bar',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CardChartAdminWidget(
                  title: 'Doctores disponibles',
                  desc: 'Doctores presentes hoy',
                  count: 12,
                  icon: Icon(Icons.medical_services),
                  chart: 'bar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              //Button módulo
              Expanded(
                  child: Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para crear cuenta de paciente
                        _addUser();
                      },
                      icon: const Icon(Icons.person_add, size: 20),
                      label: const Text(
                        'Crear usuario en el sistema',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // Sombra para darle un efecto tridimensional
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para crear cuenta de paciente
                        _addPatient();
                      },
                      icon: const Icon(Icons.person_add, size: 20),
                      label: const Text(
                        'Crear cuenta de paciente',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // Sombra para darle un efecto tridimensional
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Acción para gestionar citas
                        _addAppointmentPatient();
                      },
                      icon: const Icon(Icons.calendar_today, size: 20),
                      label: const Text(
                        'Gestionar citas',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5, // Sombra para darle un efecto tridimensional
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Tareas del día',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      Container(
                        color: Colors.white,
                        height: 300,
                        child: SfCalendar(
                          view: CalendarView.schedule,
                          firstDayOfWeek: 1,
                          initialDisplayDate: DateTime.now(),
                          initialSelectedDate: DateTime.now(),
                          dataSource: TaskDataSource(_getTareas()),
                          monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Fuente de datos para el calendario
List<Appointment> _getTareas() {
  DateTime currentDate = DateTime.now();

  return <Appointment>[
    Appointment(
      startTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        9, // Hora de inicio fija
        0,
      ),
      endTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        11, // Hora de fin fija
        0,
      ),
      subject: 'Consulta Médica',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day, // Día siguiente
        14, // Hora de inicio fija
        0,
      ),
      endTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        15, // Hora de fin fija
        30,
      ),
      subject: 'Reunión con el equipo',
      color: Colors.green,
    ),
    Appointment(
      startTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day, // Dos días después
        14,
        0,
      ),
      endTime: DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        15,
        30,
      ),
      subject: 'Revisar datos de la paciente con rut 7.881.122-1',
      color: Colors.purple,
    ),
    // Más tareas dinámicas...
  ];
}

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Appointment> source) {
    appointments = source;
  }
}
