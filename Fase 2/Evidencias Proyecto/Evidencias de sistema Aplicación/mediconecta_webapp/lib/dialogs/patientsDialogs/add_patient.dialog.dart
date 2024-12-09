import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/modal/show_status_modal.dart';
import 'package:mediconecta_webapp/models/user_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

class AddPatientDialog extends StatefulWidget {

  const AddPatientDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddPatientDialogState createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  late TextEditingController _prioridadController;
  late TextEditingController _enfermedadesCronicasController;
  late TextEditingController _alergiasController;
  // late TextEditingController _fechaNacimientoController;

  List<User> users = [];
  bool isLoading = true;

  // String? _selectedTipoUsuario;
  String? _selectedRUT;
  int? _selectedPatientID;
  String? _selectedNombre;

  // final List<String> generos = ['Masculino', 'Femenino', 'No Binario', 'Otro'];
  // final List<String> tiposUsuario = ['Doctor', 'Paciente', 'Administrador'];

  @override
  void initState() {
    super.initState();
    fetchUsersTipoPatients();
    _prioridadController = TextEditingController();
    _enfermedadesCronicasController = TextEditingController();
    _alergiasController = TextEditingController();
    // _fechaNacimientoController = TextEditingController();
  }

  void fetchUsersTipoPatients() async {
    ApiServices apiServices = ApiServices();
    List<dynamic> usersData = await apiServices.getUsersPatients();

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
  
  @override
  void dispose() {
    _prioridadController.dispose();
    _alergiasController.dispose();
    _enfermedadesCronicasController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Aquí puedes agregar la lógica para agregar un nuevo usuario.
    ApiServices().addPatient(
        usuarioId: _selectedPatientID!,
        prioridad: _prioridadController.text,
        enfermedadesCronicas: _enfermedadesCronicasController.text,
        alergias: _alergiasController.text,
        status: 'Activo',
      );

    Navigator.of(context).pop(); // Cerrar el diálogo después de guardar
    bool success = true; // Cambia esto según el resultado
    String message = 'El paciente fue agregado exitosamente.';

    showStatusModal(
      context,
      isSuccess: success,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar paciente'),
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
                    print(selectedUser.id);
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
            TextField(
              controller: _prioridadController,
              decoration: const InputDecoration(labelText: 'Prioridad'),
            ),
            TextField(
              controller: _enfermedadesCronicasController,
              decoration: const InputDecoration(labelText: 'Enfermedades crónicas'),
            ),
            TextField(
              controller: _alergiasController,
              decoration: const InputDecoration(labelText: 'Alergias'),
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
