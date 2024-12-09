import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/models/doctors_model.dart';
import 'package:mediconecta_webapp/ui/components/card_chart_admin_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Datos para la tabla de doctores
  List<Doctor> doctors = [
    Doctor(
      id: '1',
      rut: '12.345.678-9',
      nombre: 'Dr. Juan Pérez',
      especialidad: 'Cardiología',
      licencia: 'Licencia 12345',
      direccionConsulta: 'Consulta 101, Santiago',
      status: 'Presente',
    ),
    Doctor(
      id: '2',
      rut: '23.456.789-0',
      nombre: 'Dra. María López',
      especialidad: 'Pediatría',
      licencia: 'Licencia 67890',
      direccionConsulta: 'Consulta 202, Viña del Mar',
      status: 'Ausente',
    ),
    Doctor(
      id: '3',
      rut: '34.567.890-1',
      nombre: 'Dr. Pedro González',
      especialidad: 'Medicina General',
      licencia: 'Licencia 11111',
      direccionConsulta: 'Consulta 303, Concepción',
      status: 'Presente',
    ),
    Doctor(
      id: '4',
      rut: '45.678.901-2',
      nombre: 'Dra. Carolina Muñoz',
      especialidad: 'Dermatología',
      licencia: 'Licencia 22222',
      direccionConsulta: 'Consulta 404, La Serena',
      status: 'Presente',
    ),
    Doctor(
      id: '5',
      rut: '56.789.012-3',
      nombre: 'Dr. Luis Fernández',
      especialidad: 'Neurología',
      licencia: 'Licencia 33333',
      direccionConsulta: 'Consulta 505, Temuco',
      status: 'Ausente',
    ),
  ];

  // Datos para la tabla de pacientes críticos
  List<Doctor> criticalPatients = [
    Doctor(
      id: '3',
      rut: '8.765.432-1',
      nombre: 'Ana Araya Reyes',
      especialidad: 'Alta',
      licencia: 'Sin licencia',
      direccionConsulta: 'Sala UCI 1',
      status: 'Alta',
    ),
    Doctor(
      id: '4',
      rut: '7.654.321-0',
      nombre: 'Ruth Gonzalez Toro',
      especialidad: 'Alta',
      licencia: 'Sin licencia',
      direccionConsulta: 'Sala UCI 2',
      status: 'Alta',
    ),
    Doctor(
      id: '4',
      rut: '9.654.321-0',
      nombre: 'Sophia Pérez Toro',
      especialidad: 'Alta',
      licencia: 'Sin licencia',
      direccionConsulta: 'Sala UCI 2',
      status: 'Media',
    ),
    Doctor(
      id: '4',
      rut: '9.554.321-0',
      nombre: 'Alejandro Soto Fernández',
      especialidad: 'Media',
      licencia: 'Sin licencia',
      direccionConsulta: 'Sala UCI 2',
      status: 'Media',
    ),
  ];

  // Controla qué tabla mostrar (true para doctores, false para pacientes)
  bool isShowingDoctors = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Pacientes',
                      desc: 'Pacientes atendidos hoy',
                      count: 25,
                      icon: Icon(Icons.bed),
                      chart: 'bar'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Pacientes',
                      desc: 'Pacientes atendidos esta semana',
                      count: 126,
                      icon: Icon(Icons.health_and_safety_sharp),
                      chart: 'bar'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Doctores',
                      desc: 'Doctores disponibles',
                      count: 32,
                      icon: Icon(Icons.health_and_safety_sharp),
                      chart: 'bar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Salas ocupadas',
                      desc: 'Salas ocupadas ahora',
                      count: 86,
                      icon: Icon(Icons.bed),
                      chart: 'circular'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Salas libres',
                      desc: 'Salas libres ahora',
                      count: 126,
                      icon: Icon(Icons.bed),
                      chart: 'circular'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CardChartAdminWidget(
                      title: 'Ambulancias',
                      desc: 'Ambulancias disponibles ahora',
                      count: 32,
                      icon: Icon(Icons.add_road_rounded),
                      chart: 'circular'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTableContainer(), // Contenedor de la tabla
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
                          width: 1000,
                          color: Colors.white,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Tareas',
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
      ),
    );
  }

  // Contenedor dinámico que alterna entre doctores y pacientes críticos
  Widget _buildTableContainer() {
    List<Doctor> data = isShowingDoctors ? doctors : criticalPatients;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white
      ),
      child: Column(
        children: [
          Container(
            width: 1000,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isShowingDoctors ? 'Dotación de Doctores' : 'Pacientes Críticos',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isShowingDoctors = !isShowingDoctors;
                      });
                    },
                    child: Text(isShowingDoctors ? 'Ver pacientes' : 'Ver doctores'),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                const DataColumn(label: Text('RUT', style: TextStyle(fontWeight: FontWeight.bold))),
                const DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text(isShowingDoctors ? 'Asistencia' : 'Prioridad', style: const TextStyle(fontWeight: FontWeight.bold))),
                if (isShowingDoctors)
                  const DataColumn(
                    label: Text('Hora entrada', style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                else const DataColumn(
                    label: Text('Enfermedades crónicas', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                if (isShowingDoctors)
                  const DataColumn(
                    label: Text('Hora salida', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
              rows: data.map((entry) {
                return DataRow(
                  cells: [
                    DataCell(Text(entry.rut)),
                    DataCell(Text(entry.nombre)),
                    DataCell(Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: isShowingDoctors
                          ? (entry.status == 'Presente' 
                              ? const Color.fromARGB(255, 217, 243, 217) 
                              : const Color.fromARGB(255, 226, 198, 195))
                          : (entry.status == 'Alta' 
                              ? const Color.fromARGB(255, 226, 198, 195) 
                              : const Color.fromARGB(255, 206, 206, 254)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          entry.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isShowingDoctors 
                              ? (entry.status == 'Presente' ? Colors.green : Colors.red)
                              : (entry.status == 'Alta' ? Colors.red : Colors.blue),
                          ),
                        ),
                      ),
                    )),
                    if (isShowingDoctors) const DataCell(Text('10:00')) else const DataCell(Text('Diabetes tipo 2')),
                    if (isShowingDoctors) const DataCell(Text('14:00')),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Función para obtener las tareas (eventos del calendario)
List<Appointment> _getTareas() {
  return <Appointment>[
    Appointment(
      startTime: DateTime(2024, 10, 21, 9, 0),
      endTime: DateTime(2024, 10, 21, 11, 0),
      subject: 'Consulta Médica',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime(2024, 10, 22, 14, 0),
      endTime: DateTime(2024, 10, 22, 15, 30),
      subject: 'Reunión con el equipo',
      color: Colors.green,
    ),
    Appointment(
      startTime: DateTime(2024, 10, 23, 14, 0),
      endTime: DateTime(2024, 10, 23, 15, 30),
      subject: 'Revisar stock de remedios',
      color: Colors.purple,
    ),
  ];
}

// Fuente de datos personalizada para el calendario
class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Appointment> source) {
    appointments = source;
  }
}
