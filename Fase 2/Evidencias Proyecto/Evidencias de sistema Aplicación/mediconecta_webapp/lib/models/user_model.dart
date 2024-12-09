import 'package:intl/intl.dart';

class User {
  final String id;
  String rut;
  String name;
  String email;
  String telefono;
  String fechaNacimiento;
  String genero;
  String tipoUsuario;

  User({
    required this.id,
    required this.rut,
    required this.name,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.genero,
    required this.tipoUsuario,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      rut: json['rut'] ?? 'Sin RUT',
      name: json['nombre'] ?? 'Sin Nombre',
      email: json['email'] ?? 'Sin Email',
      telefono: json['telefono'] ?? 'Sin telefono',
      fechaNacimiento: json['fecha_nacimiento'] ?? 'Sin fechaNacimiento',
      genero: json['genero'] ?? 'Sin genero',
      tipoUsuario: json['tipo_usuario'] ?? 'Sin tipo Usuario',
    );
  }

  // Método para obtener la fecha en formato dd-MM-yyyy
  String getFormattedDate() {
    try {
      DateTime parsedDate = DateTime.parse(fechaNacimiento);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return fechaNacimiento; // Si no puede formatear la fecha, devuelve el valor sin cambios
    }
  }
}