import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/models/doctors_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

class DoctorsManagement extends StatefulWidget {
  const DoctorsManagement({super.key});

  @override
  _DoctorsManagementState createState() => _DoctorsManagementState();
}

class _DoctorsManagementState extends State<DoctorsManagement> {
  List<Doctor> doctors = [];
  Set<Doctor> selectedDoctors = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  void fetchDoctors() async {
    ApiServices apiServices = ApiServices();
    List<dynamic> doctorsData = await apiServices.getDoctors();

    setState(() {
      doctors = doctorsData.map((doctor) => Doctor.fromJson(doctor)).toList();
      isLoading = false;
    });
  }

  // void _editUser(Doctor doctor) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => EditUserDialog(doctor: doctor, onSave: (editedUser) {
  //       setState(() {
  //         doctor.name = editedUser.name;
  //         doctor.email = editedUser.email;
  //         doctor.telefono = editedUser.telefono;
  //         doctor.fechaNacimiento = editedUser.fechaNacimiento;
  //         doctor.genero = editedUser.genero;
  //         doctor.tipoUsuario = editedUser.tipoUsuario;
  //       });
  //     }),
  //   );
  // }

  // void _deleteUser(Doctor doctor) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => DeleteUserDialog(doctor: doctor, onDelete: () {
  //       setState(() {
  //         doctors.remove(doctor);
  //       });
  //     }),
  //   );
  // }

  bool _isSelected(Doctor doctor) {
    return selectedDoctors.contains(doctor);
  }

  void _onSelectUser(bool? selected, Doctor doctor) {
    setState(() {
      if (selected == true) {
        selectedDoctors.add(doctor);
      } else {
        selectedDoctors.remove(doctor);
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
                          'Mantenedor de doctores',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Espacio entre el título y la descripción
                        Text(
                          'Administra y gestiona la información de los doctores de la plataforma. '
                          'Puedes agregar, editar, eliminar o ver detalles de cada doctor.',
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
                      DataColumn(label: Text('Especialidad')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: doctors.map((doctor) {
                      return DataRow(
                        selected: _isSelected(doctor),
                        onSelectChanged: (selected) => _onSelectUser(selected, doctor),
                        cells: [
                          DataCell(Text(doctor.id)),
                          DataCell(Text(doctor.nombre)),
                          DataCell(Text(doctor.especialidad)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // _editUser(doctor);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    // _deleteUser(doctor);
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
