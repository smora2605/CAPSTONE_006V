// lib/dialogs/edit_user_dialog.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconecta_webapp/models/user_model.dart';

class EditUserDialog extends StatefulWidget {
  final User user;
  final ValueChanged<User> onSave;

  const EditUserDialog({
    Key? key,
    required this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _fechaNacimientoController;

  String? _selectedGenero;
  String? _selectedTipoUsuario;

  final List<String> generos = ['Masculino', 'Femenino', 'No Binario', 'Otro'];
  final List<String> tiposUsuario = ['Doctor', 'Paciente', 'Administrador'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _telefonoController = TextEditingController(text: widget.user.telefono);
    
    _fechaNacimientoController = TextEditingController(
        text: _formatDate(widget.user.fechaNacimiento));
    
    _selectedGenero = widget.user.genero;
    _selectedTipoUsuario = widget.user.tipoUsuario;
  }

  String _formatDate(String fechaNacimiento) {
    try {
      DateTime parsedDate = DateTime.parse(fechaNacimiento);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return fechaNacimiento;
    }
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
        _fechaNacimientoController.text =
            DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Usuario'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _fechaNacimientoController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de Nacimiento'),
                ),
              ),
            ),
            DropdownButtonFormField<String>(
              value: _selectedGenero,
              decoration: const InputDecoration(labelText: 'Género'),
              items: generos.map((String genero) {
                return DropdownMenuItem<String>(
                  value: genero,
                  child: Text(genero),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGenero = newValue;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedTipoUsuario,
              decoration: const InputDecoration(labelText: 'Tipo de usuario'),
              items: tiposUsuario.map((String tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTipoUsuario = newValue;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                widget.onSave(
                  User(
                    id: widget.user.id,
                    name: _nameController.text,
                    email: _emailController.text,
                    telefono: _telefonoController.text,
                    fechaNacimiento: _fechaNacimientoController.text,
                    genero: _selectedGenero ?? widget.user.genero,
                    tipoUsuario: _selectedTipoUsuario ?? widget.user.tipoUsuario,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 20,),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }
}
