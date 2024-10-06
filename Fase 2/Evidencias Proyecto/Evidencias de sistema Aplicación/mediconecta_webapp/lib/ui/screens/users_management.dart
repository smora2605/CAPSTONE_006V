import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/dialogs/delete_user_dialog.dart';
import 'package:mediconecta_webapp/dialogs/edit_user_dialog.dart';
import 'package:mediconecta_webapp/models/user_model.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

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
                          'Mantenedor de usuarios',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // Espacio entre el título y la descripción
                        Text(
                          'Administra y gestiona la información de los usuarios de la plataforma. '
                          'Puedes agregar, editar, eliminar o ver detalles de cada usuario.',
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
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Telefono')),
                      DataColumn(label: Text('Fecha de nacimiento')),
                      DataColumn(label: Text('Genero')),
                      DataColumn(label: Text('Tipo de usuario')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        selected: _isSelected(user),
                        onSelectChanged: (selected) => _onSelectUser(selected, user),
                        cells: [
                          DataCell(Text(user.id)),
                          DataCell(Text(user.name)),
                          DataCell(Text(user.email)),
                          DataCell(Text(user.telefono)),
                          // Aquí usamos la función getFormattedDate para mostrar la fecha formateada
                          DataCell(Text(user.getFormattedDate())),
                          DataCell(Text(user.genero)),
                          DataCell(Text(user.tipoUsuario)),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _editUser(user);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
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
          );
  }
}
