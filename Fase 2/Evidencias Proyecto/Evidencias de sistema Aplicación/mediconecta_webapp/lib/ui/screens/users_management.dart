import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/add_user_dialog.dart';
import 'package:mediconecta_webapp/dialogs/delete_user_dialog.dart';
import 'package:mediconecta_webapp/dialogs/edit_user_dialog.dart';
import 'package:mediconecta_webapp/models/user_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';

class UsersManagement extends StatefulWidget {
  const UsersManagement({super.key});

  @override
  _UsersManagementState createState() => _UsersManagementState();
}

class _UsersManagementState extends State<UsersManagement> {
  List<User> users = [];
  Set<User> selectedUsers = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    ApiServices apiServices = ApiServices();
    List<dynamic> usersData = await apiServices.getUsers();

    setState(() {
      users = usersData.map((user) => User.fromJson(user)).toList();
      isLoading = false;
    });
  }

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => const AddUserDialog(),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => EditUserDialog(user: user, onSave: (editedUser) {
        setState(() {
          user.name = editedUser.name;
          user.email = editedUser.email;
          user.telefono = editedUser.telefono;
          user.fechaNacimiento = editedUser.fechaNacimiento;
          user.genero = editedUser.genero;
          user.tipoUsuario = editedUser.tipoUsuario;
        });
      }),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => DeleteUserDialog(user: user, onDelete: () {
        setState(() {
          users.remove(user);
        });
      }),
    );
  }

  bool _isSelected(User user) {
    return selectedUsers.contains(user);
  }

  void _onSelectUser(bool? selected, User user) {
    setState(() {
      if (selected == true) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Encabezado con acciones (Agregar, Importar, Exportar, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Usuarios',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        MaterialButton(
                          onPressed: _addUser,
                          color: AppColors.primaryColor,
                          textColor: AppColors.textColorPrimary,
                          child: const Text('Agregar'),
                        ),
                        const SizedBox(width: 20),
                        MaterialButton(
                          onPressed: () {},
                          color: AppColors.primaryColor,
                          textColor: AppColors.textColorPrimary,
                          child: const Text('Importar'),
                        ),
                        const SizedBox(width: 20),
                        MaterialButton(
                          onPressed: () {},
                          color: AppColors.primaryColor,
                          textColor: AppColors.textColorPrimary,
                          child: const Text('Exportar (Excel)'),
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () {},
                      textColor: AppColors.textColorPrimary,
                      color: AppColors.primaryColor,
                      child: const Text('Filtrar'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Aquí se aplica un SizedBox para limitar la altura de la tabla
                SizedBox(
                  height: 440, // Define la altura máxima para la tabla
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Añadir scroll horizontal a la tabla de usuarios
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const <DataColumn>[
                              // DataColumn(label: Text('ID')),
                              DataColumn(label: Text('RUT')),
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Teléfono')),
                              DataColumn(label: Text('Fecha de Nacimiento')),
                              DataColumn(label: Text('Género')),
                              DataColumn(label: Text('Tipo de Usuario')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rows: users.map((user) {
                              return DataRow(
                                selected: _isSelected(user),
                                onSelectChanged: (selected) =>
                                    _onSelectUser(selected, user),
                                cells: [
                                  // DataCell(Text(user.id)),
                                  DataCell(Text(user.rut)),
                                  DataCell(Text(user.name)),
                                  DataCell(Text(user.email)),
                                  DataCell(Text(user.telefono)),
                                  DataCell(Text(user.getFormattedDate())),
                                  DataCell(Text(user.genero)),
                                  DataCell(Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: user.tipoUsuario == 'Administrador'
                                          ? const Color.fromARGB(
                                              255, 248, 249, 164)
                                          : user.tipoUsuario == 'Doctor'
                                              ? const Color.fromARGB(
                                                  255, 163, 205, 239)
                                            : user.tipoUsuario == 'Recepcionista'
                                                ? const Color.fromARGB(255, 239, 216, 163)
                                                  : const Color.fromARGB(
                                                      255, 217, 243, 217),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(
                                        user.tipoUsuario,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: user.tipoUsuario ==
                                                  'Administrador'
                                              ? Colors.orange
                                              : user.tipoUsuario == 'Doctor'
                                                  ? Colors.blue
                                                  : Colors.green,
                                        ),
                                      ),
                                    ),
                                  )),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            _editUser(user);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteUser(user);
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
          );
  }
}
