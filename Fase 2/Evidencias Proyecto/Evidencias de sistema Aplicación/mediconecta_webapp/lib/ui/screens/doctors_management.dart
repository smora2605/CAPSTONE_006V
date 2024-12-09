import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/models/doctors_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';

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
                              'Doctores',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),
                            ),

                          ),
                          const SizedBox(width: 20),
                          MaterialButton(onPressed: (){}, color: AppColors.primaryColor, textColor: AppColors.textColorPrimary, child: const Text('Agregar'),),
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
              
                  //Tabla de doctores
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
                                DataColumn(label: Text('Especialidad')),
                                DataColumn(label: Text('Licencia')),
                                DataColumn(label: Text('Dirección consulta')),
                                DataColumn(label: Text('Estado')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: doctors.map((doctor) {
                                return DataRow(
                                  selected: _isSelected(doctor),
                                  onSelectChanged: (selected) => _onSelectUser(selected, doctor),
                                  cells: [
                                    // DataCell(Text(doctor.id)),
                                    DataCell(Text(doctor.rut)),
                                    DataCell(Text(doctor.nombre)),
                                    DataCell(Text(doctor.especialidad)),
                                    DataCell(Text(doctor.licencia)),
                                    DataCell(Text(doctor.direccionConsulta)),
                                    DataCell(Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: doctor.status == 'Activo'
                                            ? const Color.fromARGB(255, 217, 243, 217)
                                            : const Color.fromARGB(255, 226, 198, 195),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          doctor.status,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: doctor.status == 'Activo'
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
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
