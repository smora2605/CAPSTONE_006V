import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mediconecta_webapp/dialogs/modal/show_status_modal.dart';
import 'package:mediconecta_webapp/services/api_services.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddUserDialogState createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  late TextEditingController _rutController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _telefonoController;
  late TextEditingController _fechaNacimientoController;

  String? _selectedTipoUsuario;
  String? _selectedGenero;

  String? _rutValidationMessage; // Mensaje de validación del RUT

  final List<String> generos = ['Masculino', 'Femenino', 'No Binario', 'Otro'];
  final List<String> tiposUsuario = ['Doctor', 'Paciente', 'Recepcionista', 'Administrador'];

  @override
  void initState() {
    super.initState();
    _rutController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _telefonoController = TextEditingController();
    _fechaNacimientoController = TextEditingController();

    // Listener para validar el RUT en tiempo real
    _rutController.addListener(() {
      setState(() {
        _rutValidationMessage = _validateRUT(_rutController.text);
      });
    });
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
    _rutController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
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

  String? _validateRUT(String rut) {
    final regExp = RegExp(r'^\d{6,7}-[0-9kK]$');
    if (rut.isEmpty) {
      return 'El RUT no puede estar vacío.';
    } else if (!regExp.hasMatch(rut)) {
      return 'Formato de RUT inválido. Ej: xxxxxxxx-x';
    }
    return null; // RUT válido
  }

  void _handleSave() {
    // Validar campos antes de enviar
    if (_rutController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        _fechaNacimientoController.text.isEmpty ||
        _selectedGenero == null ||
        _selectedTipoUsuario == null ||
        _rutValidationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos correctamente.')),
      );
      return;
    }

    ApiServices().addUser(
      rut: _rutController.text,
      nombre: _nameController.text,
      email: _emailController.text,
      telefono: _telefonoController.text,
      fechaNacimiento: _fechaNacimientoController.text,
      genero: _selectedGenero!,
      tipoUsuario: _selectedTipoUsuario!,
      password: _passwordController.text,
    );

    Navigator.of(context).pop();
    // Lógica para guardar datos
    bool success = true; // Cambia esto según el resultado
    String message = 'El usuario fue agregado exitosamente.';

    showStatusModal(
      context,
      isSuccess: success,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Center(
        child: Text(
          'Agregar Usuario',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.blueGrey[800],
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _buildTextField(
              _rutController,
              'RUT',
              suffixIcon: Icons.perm_identity,
            ),
            if (_rutValidationMessage != null)
              Text(
                _rutValidationMessage!,
                style: TextStyle(
                  color: _rutValidationMessage == null ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 12),
            _buildTextField(_nameController, 'Nombre'),
            const SizedBox(height: 12),
            _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildTextField(_telefonoController, 'Teléfono', keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  _fechaNacimientoController,
                  'Fecha de Nacimiento',
                  suffixIcon: Icons.calendar_today,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _selectedGenero,
              label: 'Género',
              items: generos,
              onChanged: (value) => setState(() {
                _selectedGenero = value;
              }),
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _selectedTipoUsuario,
              label: 'Tipo de Usuario',
              items: tiposUsuario,
              onChanged: (value) => setState(() {
                _selectedTipoUsuario = value;
              }),
            ),
            const SizedBox(height: 12),
            _buildTextField(_passwordController, 'Contraseña', obscureText: true),
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
              const SizedBox(width: 20),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, bool obscureText = false, IconData? suffixIcon}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
