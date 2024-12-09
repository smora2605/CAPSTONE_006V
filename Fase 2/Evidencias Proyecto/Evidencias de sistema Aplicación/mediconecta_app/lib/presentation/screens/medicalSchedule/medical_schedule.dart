import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconecta_app/api/apiService.dart';

class MedicalSchedule extends StatelessWidget {
  const MedicalSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat.yMMMMd('es_ES').format(DateTime.now());

    final ApiService apiService = ApiService();

    Future<List<Map<String, dynamic>>> getMedicationAppointments() async {
      try {
        // Llamar al servicio para obtener los recordatorios
        final List<dynamic> response = await apiService.getRecordatorios();

        print('responseRender $response');

        // Mapear los recordatorios al esquema deseado
        final List<Map<String, dynamic>> medicationAppointments =
            response.map<Map<String, dynamic>>((recordatorio) {

            // Suponemos que las horas están en formato 'HH:mm'
            final String horaInicio = '19:00'; // Ejemplo: '19:00'
            final String horaFin = '20:00'; // Ejemplo: '20:00'

            // Combinar la fecha actual con la hora proporcionada
            final DateTime startTime = DateTime.parse(
                '${DateTime.now().toIso8601String().split('T')[0]}T$horaInicio:00'); // Fecha + Hora
            final DateTime endTime = DateTime.parse(
                '${DateTime.now().toIso8601String().split('T')[0]}T$horaFin:00');

          return {
            'startTime': startTime, // Inicio
            'endTime': endTime, // Fin
            'subject': recordatorio['desc_medicamento'], // Nombre del medicamento
            'color': Colors.green, // Color según prioridad
          };
        }).toList();

        return medicationAppointments;
      } catch (e) {
        print('Error al obtener los recordatorios: $e');
        return [];
      }
    }

    // Asignar color según prioridad
    Color _assignColor(String prioridad) {
      switch (prioridad.toLowerCase()) {
        case 'alta':
          return Colors.red;
        case 'media':
          return Colors.orange;
        case 'baja':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de Medicamentos')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueGrey,
            child: Text(
              'Fecha de hoy: $currentDate',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Medicamentos del día',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getMedicationAppointments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Mostrar indicador de carga mientras se obtienen los datos
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Mostrar mensaje de error si ocurre algún problema
                  return Center(
                    child: Text(
                      'Error al cargar los medicamentos: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Mostrar mensaje si no hay medicamentos
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '¡Sin Medicamentos Programados!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No tienes medicamentos pendientes para hoy.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                else {
                  // Mostrar lista de medicamentos
                  final medications = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medication = medications[index];
                      return MedicationCard(medication: medication);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationCard extends StatefulWidget {
  final Map<String, dynamic> medication;

  const MedicationCard({Key? key, required this.medication}) : super(key: key);

  @override
  _MedicationCardState createState() => _MedicationCardState();
}

class _MedicationCardState extends State<MedicationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configuración del AnimationController para el efecto palpitante
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Hace que la animación vaya y venga

    // La animación va de 0 a 1 para controlar la opacidad del borde
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime startTime = widget.medication['startTime'];

    // Verifica si la hora actual está dentro de una hora desde el inicio del medicamento
    final bool isCurrent = now.isAfter(startTime) &&
        now.isBefore(startTime.add(const Duration(hours: 1)));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: isCurrent
                  ? Colors.red.withOpacity(_animation.value) // Borde palpitante
                  : Colors.transparent, // Sin borde si no está en el rango de tiempo
              width: isCurrent ? 4 : 0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: child,
        );
      },
      child: Card(
        color: widget.medication['color'],
        child: ListTile(
          leading: const Icon(
            Icons.alarm,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            widget.medication['subject'],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'A las: ${DateFormat.Hm().format(startTime)}',
            style: const TextStyle(fontSize: 20, color: Colors.white70),
          ),
          trailing: const Icon(Icons.medical_services, color: Colors.white),
        ),
      ),
    );
  }
}
