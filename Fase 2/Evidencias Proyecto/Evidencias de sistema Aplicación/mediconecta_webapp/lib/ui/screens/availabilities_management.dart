import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AvailabilitiesManagement extends StatefulWidget {
  const AvailabilitiesManagement({super.key});

  @override
  _AvailabilitiesManagementState createState() =>
      _AvailabilitiesManagementState();
}

class _AvailabilitiesManagementState extends State<AvailabilitiesManagement> {
  final List<Appointment> _appointments = [];
  List<Map<String, dynamic>> _availabilities = [];
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  List<String> _selectedDays = [];
  String? _selectedDoctor;
  List<dynamic> doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailabilities();
    _fetchDoctorsOptions();
  }

  /// Función que llama al servicio para obtener todas las disponibilidades
  Future<void> _fetchAvailabilities() async {
    try {
      final data = await ApiServices().getAvailabilities();
      setState(() {
        _availabilities = data;

        // Mapeamos las disponibilidades a objetos Appointment para el calendario
        _appointments.clear();
        _appointments.addAll(_availabilities.map((availability) {
          // Parseamos la fecha y la hora
          // Primero, obtenemos solo la fecha en formato 'YYYY-MM-DD'
          String dateString = availability['fecha'].split('T')[0]; // '2024-08-21'
          
          // Ahora formamos la cadena de fecha y hora completa
          String fullStartTimeString = '$dateString ${availability['hora_inicio']}';
          String fullEndTimeString = '$dateString ${availability['hora_fin']}';

          // Usamos DateTime.parse para crear las instancias de DateTime
          DateTime startTime = DateTime.parse(fullStartTimeString);
          DateTime endTime = DateTime.parse(fullEndTimeString);

          // Obtener el prefijo y color
          String gender = availability['genero'] ?? ''; // Manejo de null aquí
          String doctorName = availability['doctor_nombre'] ?? 'Sin nombre'; // Valor por defecto
          String specialty = availability['especialidad_nombre'] ?? 'Sin especialidad'; // Valor por defecto
          // Color appointmentColor = getSpecialtyColor(specialty);

          final prefix = (gender == 'Femenino') ? 'Dra.' : 'Dr.';

          return Appointment(
            startTime: startTime,
            endTime: endTime,
            subject: '$prefix $doctorName - $specialty',
            color: specialty == 'Cardiología' ? Colors.red
              : specialty == 'Pediatría' ? Colors.green : Colors.blue
          );
        }).toList());
      });
    } catch (e) {
      print('Error al obtener disponibilidades: $e');
    }
  }

  void _fetchDoctorsOptions() async {
    try {
      ApiServices apiServices = ApiServices();
      final doctorData = await apiServices.getDoctorsNames();

      setState(() {
        doctors = doctorData != null
            ? List<Map<String, dynamic>>.from(doctorData)
            : [];
      });

      print('doctors $doctors');
    } catch (e) {
      print('Error al traer los doctores names $e');
    }
  }

  final Map<int, String> _weekdays = {
    1: 'Lunes',
    2: 'Martes',
    3: 'Miércoles',
    4: 'Jueves',
    5: 'Viernes',
  };

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height / 1.2,
      child: SfCalendar(
        view: CalendarView.workWeek,
        firstDayOfWeek: 1,
        initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now(),
        dataSource: MeetingDataSource(_appointments),
        allowDragAndDrop: true,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeIntervalHeight: 50,
          timeInterval: Duration(minutes: 30),
          startHour: 7,
          endHour: 21,
          timeFormat: 'HH:mm',
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell &&
              details.date != null) {
            _selectedStartTime = details.date;
            _selectedEndTime = _selectedStartTime!.add(const Duration(minutes: 30));

            final selectedDayName = _weekdays[details.date!.weekday];
            if (selectedDayName != null && !_selectedDays.contains(selectedDayName)) {
              _selectedDays = [selectedDayName];
            }

            _openAvailabilityDialog(context);
          }
        },
      ),
    );
  }

  Future<void> _openAvailabilityDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Añadir Disponibilidad'),
              content: _buildAvailabilityForm(setDialogState),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addAvailability();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAvailabilityForm(void Function(void Function()) setDialogState) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Hora de Inicio:'),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectTime(context, true, setDialogState),
                  child: Text(_selectedStartTime != null
                      ? _formatTime(_selectedStartTime!)
                      : 'Seleccionar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Hora de Fin:'),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _selectTime(context, false, setDialogState),
                  child: Text(_selectedEndTime != null
                      ? _formatTime(_selectedEndTime!)
                      : 'Seleccionar'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Seleccionar Doctor'),
            value: _selectedDoctor,
            items: doctors.isNotEmpty
                ? doctors.map((doctor) {
                    final id = doctor['id']?.toString() ?? '0';
                    final name = doctor['nombre'] ?? 'Sin nombre';
                    final gender = doctor['genero'] ?? '';
                    final specialty = doctor['especialidad'] ?? 'Sin especialidad';

                    final prefix = (gender == 'Femenino') ? 'Dra.' : 'Dr.';

                    return DropdownMenuItem(
                      value: id,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$prefix $name',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4,),
                          Text(
                            specialty,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                : [],
            onChanged: (value) {
              setState(() {
                _selectedDoctor = value;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Días de la semana:'),
          ..._weekdays.values.map(
            (day) => CheckboxListTile(
              title: Text(day),
              value: _selectedDays.contains(day),
              onChanged: (bool? selected) {
                setDialogState(() {
                  if (selected == true) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime,
      void Function(void Function()) setDialogState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        isStartTime ? _selectedStartTime! : _selectedEndTime ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setDialogState(() {
        final newDateTime = DateTime(
          _selectedStartTime!.year,
          _selectedStartTime!.month,
          _selectedStartTime!.day,
          picked.hour,
          picked.minute,
        );

        if (isStartTime) {
          _selectedStartTime = newDateTime;
          _selectedEndTime = newDateTime.add(const Duration(minutes: 30));
        } else {
          _selectedEndTime = newDateTime;
        }
      });
    }
  }

  void _addAvailability() async {
    if (_selectedStartTime != null &&
        _selectedEndTime != null &&
        _selectedDoctor != null &&
        _selectedDays.isNotEmpty) {
      try {
        // Validar que la hora de inicio sea posterior a la hora actual
        final now = DateTime.now();

        // Si la hora seleccionada ya pasó, mostrar un mensaje de error
        if (_selectedStartTime!.isBefore(now)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No puedes crear disponibilidades en horas pasadas.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Formateamos la hora para enviarla a la API
        final String horaInicio = _formatTime(_selectedStartTime!); // HH:mm
        final String horaFin = _formatTime(_selectedEndTime!); // HH:mm

        // Obtenemos la fecha base seleccionada (por ejemplo, si seleccionaste un día en el calendario)
        DateTime baseDate = _selectedStartTime!;

        for (String day in _selectedDays) {
          // Encontramos la fecha real correspondiente al día seleccionado (martes, miércoles, etc.)
          DateTime targetDate = _findNextWeekday(baseDate, _getDayIndex(day));

          final String fechaDia = targetDate.toIso8601String().split('T')[0]; // Formato YYYY-MM-DD

          // Llamada a la API para cada día seleccionado
          final response = await ApiServices().addAvailability(
            doctorId: int.parse(_selectedDoctor!),
            fecha: fechaDia,
            horaInicio: horaInicio,
            horaFin: horaFin,
          );

          if (response.isNotEmpty) {
            print('Disponibilidad creada para el $day: $response');
            
            // Opcionalmente, añadimos la disponibilidad al calendario local
            setState(() {
              _appointments.add(
                Appointment(
                  startTime: DateTime(
                    targetDate.year,
                    targetDate.month,
                    targetDate.day,
                    _selectedStartTime!.hour,
                    _selectedStartTime!.minute,
                  ),
                  endTime: DateTime(
                    targetDate.year,
                    targetDate.month,
                    targetDate.day,
                    _selectedEndTime!.hour,
                    _selectedEndTime!.minute,
                  ),
                  subject: 'Disponibilidad - $_selectedDoctor',
                  color: Colors.green,
                ),
              );
            });
          }
        }
        _fetchAvailabilities();
      } catch (e) {
        print('Error al crear la disponibilidad: $e');
      }
    }
  }


  DateTime _findNextWeekday(DateTime startDate, int targetDay) {
    int daysToAdd = (targetDay - startDate.weekday) % 7;
    if (daysToAdd < 0) daysToAdd += 7; // Aseguramos que no haya valores negativos
    return startDate.add(Duration(days: daysToAdd));
  }

  int _getDayIndex(String day) {
    switch (day.toLowerCase()) {
      case 'lunes':
        return 1;
      case 'martes':
        return 2;
      case 'miércoles':
        return 3;
      case 'jueves':
        return 4;
      case 'viernes':
        return 5;
      case 'sábado':
        return 6;
      case 'domingo':
        return 7;
      default:
        throw ArgumentError('Día inválido: $day');
    }
  }

}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
