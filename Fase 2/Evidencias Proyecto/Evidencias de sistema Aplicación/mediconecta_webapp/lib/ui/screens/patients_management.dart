import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/patientsDialogs/add_patient.dialog.dart';
import 'package:mediconecta_webapp/models/patient_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';

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

  void _addPatient() {
    showDialog(
      context: context,
      builder: (context) => const AddPatientDialog(),
    );
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            child: Text(
                              'Pacientes',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),
                            ),
              
                          ),
                          const SizedBox(width: 20),
                          MaterialButton(onPressed: (){_addPatient();}, color: AppColors.primaryColor, textColor: AppColors.textColorPrimary, child: const Text('Agregar'),),
                          const SizedBox(width: 20),
                          MaterialButton(onPressed: (){}, color: AppColors.primaryColor, textColor: AppColors.textColorPrimary, child: const Text('Importar'),),
                          const SizedBox(width: 20),
                          MaterialButton(onPressed: (){}, color: AppColors.primaryColor, textColor: AppColors.textColorPrimary, child: const Text('Exportar (Excel)'),),
                        ],
                      ),
                      Row(
                        children: [
                          MaterialButton(onPressed: (){}, textColor: AppColors.textColorPrimary, color: AppColors.primaryColor, child: const Text('Filtrar'),),
                        ],
                      ),
                    ],
                  ),
              
                  const SizedBox(height: 20),
              
                  //Tabla de usuarios
                  SizedBox(
                    height: 440,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const <DataColumn>[
                                // DataColumn(label: Text('ID')),
                                DataColumn(label: Text('RUT')),
                                DataColumn(label: Text('Nombre')),
                                DataColumn(label: Text('Prioridad')),
                                DataColumn(label: Text('Enfermedades crónicas')),
                                DataColumn(label: Text('Alergias')),
                                DataColumn(label: Text('Estado')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: patients.map((patient) {
                                return DataRow(
                                  selected: _isSelected(patient),
                                  onSelectChanged: (selected) => _onSelectUser(selected, patient),
                                  cells: [
                                    // DataCell(Text(patient.id)),
                                    DataCell(Text(patient.rut)),
                                    DataCell(Text(patient.nombre)),
                                    DataCell(Text(patient.prioridad)),
                                    DataCell(Text(patient.enfermedadesCronicas)),
                                    DataCell(Text(patient.alergias)),
                                    DataCell(Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: patient.status == 'Activo'
                                            ? const Color.fromARGB(255, 217, 243, 217)
                                            : const Color.fromARGB(255, 226, 198, 195),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          patient.status,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: patient.status == 'Activo'
                                            ? Colors.green
                                            : Colors.red
                                          ),
                                        ),
                                      ),
                                    )),
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
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
