import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/models/patient_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

class PatientsManagement extends StatefulWidget {
  const PatientsManagement({super.key});

  @override
  _PatientsManagementState createState() => _PatientsManagementState();
}

class _PatientsManagementState extends State<PatientsManagement> {
  List<Patient> patients = [];
  Set<Patient> selectedPatients = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  void fetchPatients() async {
    ApiServices apiServices = ApiServices();
    List<dynamic> patientsData = await apiServices.getPatients();

    setState(() {
      patients = patientsData.map((patient) => Patient.fromJson(patient)).toList();
      isLoading = false;
    });
  }

  // void _editUser(Patient patient) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => EditUserDialog(patient: patient, onSave: (editedUser) {
  //       setState(() {
  //         patient.name = editedUser.name;
  //         patient.email = editedUser.email;
  //         patient.telefono = editedUser.telefono;
  //         patient.fechaNacimiento = editedUser.fechaNacimiento;
  //         patient.genero = editedUser.genero;
  //         patient.tipoUsuario = editedUser.tipoUsuario;
  //       });
  //     }),
  //   );
  // }

  // void _deleteUser(Patient patient) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => DeleteUserDialog(patient: patient, onDelete: () {
  //       setState(() {
  //         patients.remove(patient);
  //       });
  //     }),
  //   );
  // }

  bool _isSelected(Patient patient) {
    return selectedPatients.contains(patient);
  }

  void _onSelectUser(bool? selected, Patient patient) {
    setState(() {
      if (selected == true) {
        selectedPatients.add(patient);
      } else {
        selectedPatients.remove(patient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Título y descripción
                SizedBox(
                  width: size.width,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Margen alrededor del título y la descripción
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mantenedor de pacientes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Espacio entre el título y la descripción
                        Text(
                          'Administra y gestiona la información de los pacientes de la plataforma. '
                          'Puedes agregar, editar, eliminar o ver detalles de cada paciente.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre el título y la descripción
            
            
                //Tabla de usuarios
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: patients.map((patient) {
                      return DataRow(
                        selected: _isSelected(patient),
                        onSelectChanged: (selected) => _onSelectUser(selected, patient),
                        cells: [
                          DataCell(Text(patient.id)),
                          DataCell(Text(patient.nombre)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // _editUser(patient);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // _deleteUser(patient);
                                  },
                                ),
                              ],
                            ),
                          ),
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
