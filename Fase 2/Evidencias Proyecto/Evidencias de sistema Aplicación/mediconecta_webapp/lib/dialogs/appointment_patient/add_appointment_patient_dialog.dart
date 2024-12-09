import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconecta_webapp/dialogs/modal/show_status_modal.dart';
import 'package:mediconecta_webapp/models/user_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

class AddAppointmentPatientDialog extends StatefulWidget {

  const AddAppointmentPatientDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddAppointmentPatientDialogState createState() => _AddAppointmentPatientDialogState();
}

class _AddAppointmentPatientDialogState extends State<AddAppointmentPatientDialog> {
  late TextEditingController _fechaController;

  List<User> users = [];
  List<Map<String, dynamic>> dispo = [];
  bool isLoading = true;

  // String? _selectedTipoUsuario;
  String? _selectedRUT;
  int? _selectedPatientID;
  String? _selectedNombre;

  ApiServices apiServices = ApiServices();

  Map<String, dynamic>? _selectedDoctor;
  String? _selectedHora;
  List<String> horasDisponibles = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
    _fechaController = TextEditingController();
  }

  void fetchPatients() async {
    List<dynamic> usersData = await apiServices.getPatients();

    setState(() {
      users = usersData.map((user) => User.fromJson(user)).toList();
      // isLoading = false;
    });
  }

  void _updateNameFromRUT(String? rut) {
    if (rut == null) {
      _selectedNombre = ''; // Limpiar el nombre si no hay RUT seleccionado
      return;
    }

    // Buscar el usuario correspondiente al RUT seleccionado
    final selectedUser = users.firstWhere((user) => user.rut == rut);
    if (selectedUser != null) {
      _selectedNombre = selectedUser.name; // Rellenar el nombre
    }
  }

  void fetchAvailabilitiesForDate(String fecha) async {
    List<Map<String, dynamic>> disponibilidades = await apiServices.getAvailabilitiesByDate(fecha);

    if (disponibilidades.isNotEmpty) {
      setState(() {
        dispo = disponibilidades;
      });
      print('Disponibilidades en $fecha: $disponibilidades');
    } else {
      print('No se encontraron disponibilidades para la fecha $fecha.');
    }
  }

  void showStatusModal(BuildContext context, {required bool isSuccess, required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return StatusModal(
          title: isSuccess ? 'Éxito' : 'Error',
          message: message,
          icon: isSuccess ? Icons.check_circle : Icons.error,
          iconColor: isSuccess ? Colors.green : Colors.red,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _fechaController.text = DateFormat('yyyy-MM-dd').format(selectedDate); // Asegúrate de que el formato coincida con la API

        // Llama a la función con la fecha seleccionada
        fetchAvailabilitiesForDate(_fechaController.text);
      });
    }
  }

  List<String> calcularIntervalos15Minutos(String horaInicio, String horaFin) {
    List<String> intervalos = [];
    DateTime inicio = DateFormat('HH:mm:ss').parse(horaInicio);
    DateTime fin = DateFormat('HH:mm:ss').parse(horaFin);

    while (inicio.isBefore(fin)) {
      intervalos.add(DateFormat('HH:mm').format(inicio));
      inicio = inicio.add(const Duration(minutes: 15));
    }

    return intervalos;
  }


  @override
  void dispose() {
    super.dispose();
  }

  void _handleSave() async {
    // Validar que todos los datos requeridos están presentes
    if (_selectedPatientID == null ||
        _selectedDoctor == null ||
        _selectedHora == null ||
        _fechaController.text.isEmpty) {
      return;
    }

    try {
      // Llama a la función para crear una cita
      List<Map<String, dynamic>> response = await ApiServices().createCita(
        pacienteId: _selectedPatientID!,
        doctorId: _selectedDoctor!['doctor_id'],
        fecha: DateFormat('yyyy-MM-dd').parse(_fechaController.text),
        hora: _selectedHora!,
        motivo: '', // Puedes usar esto como motivo
        estado: 'Pendiente', // Estado inicial de la cita
      );

      // Verifica si la cita fue creada correctamente
      if (response.isNotEmpty) {
        print('Cita creada con éxito: $response');
        Navigator.of(context).pop(); // Cierra el diálogo
        // Lógica para guardar datos
        bool success = true; // Cambia esto según el resultado
        String message = 'La cita fue agregada exitosamente.';

        showStatusModal(
          context,
          isSuccess: success,
          message: message,
        );
      } else {
        print('Error al crear la cita.');
      }
    } catch (e) {
      print('Error en _handleSave: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear cita medica'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<User>(
              value: users.isNotEmpty && _selectedRUT != null
                ? users.firstWhere(
                    (user) => user.rut == _selectedRUT, 
                    orElse: () => users.first, // Retorna el primer usuario si no se encuentra coincidencia
                  )
                : null,
              decoration: const InputDecoration(labelText: 'RUT'),
              items: users.map((User user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.rut),
                );
              }).toList(),
              onChanged: (User? selectedUser) {
                setState(() {
                  if (selectedUser != null) {
                    _selectedRUT = selectedUser.rut;
                    print('selectedUser.id ${selectedUser.id}');
                    _selectedPatientID = int.parse(selectedUser.id);
                    print(_selectedPatientID);
                    _updateNameFromRUT(selectedUser.rut);  // Actualizar el nombre desde el RUT
                  }
                });
              },
            ),
            IgnorePointer(
              child: DropdownButtonFormField<String>(
                value: _selectedNombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                items: users.map((User user) {
                  return DropdownMenuItem<String>(
                    value: user.name,
                    child: Text(user.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedNombre = newValue;
                  });
                },
              ),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _fechaController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha'),
                ),
              ),
            ),
            DropdownButtonFormField<Map<String, dynamic>>(
              value: null, // Inicialmente no seleccionamos nada
              decoration: const InputDecoration(labelText: 'Doctores disponibles'),
              items: dispo.map((doctor) {
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: doctor,
                  child: Text(
                    '${doctor['doctor_nombre']} (${doctor['especialidad_nombre']})',
                  ), // Muestra el nombre del doctor y su especialidad
                );
              }).toList(),
              onChanged: (Map<String, dynamic>? selectedDoctor) {
                setState(() {
                  _selectedDoctor = selectedDoctor;
                  if (selectedDoctor != null) {
                    horasDisponibles = calcularIntervalos15Minutos(
                      selectedDoctor['hora_inicio'],
                      selectedDoctor['hora_fin'],
                    );
                  }
                });
              },
            ),

            DropdownButtonFormField<String>(
              value: _selectedHora, // Valor inicial
              decoration: const InputDecoration(labelText: 'Horas disponibles'),
              items: horasDisponibles.map((hora) {
                return DropdownMenuItem<String>(
                  value: hora,
                  child: Text(hora),
                );
              }).toList(),
              onChanged: (String? selectedHora) {
                setState(() {
                  _selectedHora = selectedHora;
                  print('Hora seleccionada: $_selectedHora');
                });
              },
            ),

          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleSave,
                icon: const Icon(Icons.check),
                label: const Text('Guardar'),
              ),
              const SizedBox(width: 20,),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
