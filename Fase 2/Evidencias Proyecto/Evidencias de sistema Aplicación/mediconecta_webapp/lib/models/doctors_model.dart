import 'package:intl/intl.dart';

class Doctor {
  final String id;
  final String nombre; // Nombre del doctor
  final String especialidad; // Especialidad del doctor

  Doctor({
    required this.id,
    required this.nombre,
    required this.especialidad,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? 'Sin Nombre',
      especialidad: json['especialidad'] ?? 'Sin especialidad',
    );
  }

  // Método para obtener la fecha en formato dd-MM-yyyy
  // String getFormattedDate() {
  //   try {
  //     DateTime parsedDate = DateTime.parse(fechaNacimiento);
  //     return DateFormat('dd-MM-yyyy').format(parsedDate);
  //   } catch (e) {
  //     return fechaNacimiento; // Si no puede formatear la fecha, devuelve el valor sin cambios
  //   }
  // }
}
