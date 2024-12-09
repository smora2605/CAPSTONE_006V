

class Doctor {
  final String id;
  final String rut;
  final String nombre;
  final String especialidad;
  final String licencia;
  final String direccionConsulta;
  final String status;

  Doctor({
    required this.id,
    required this.rut,
    required this.nombre,
    required this.especialidad,
    required this.licencia,
    required this.direccionConsulta,
    required this.status,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'].toString(),
      rut: json['rut'] ?? 'Sin RUT',
      nombre: json['nombre'] ?? 'Sin Nombre',
      especialidad: json['especialidad'] ?? 'Sin especialidad',
      licencia: json['licencia_medica'] ?? 'Sin licencia',
      direccionConsulta: json['direccion_consulta'] ?? 'Sin dirección',
      status: json['status'] ?? 'Sin status',
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
