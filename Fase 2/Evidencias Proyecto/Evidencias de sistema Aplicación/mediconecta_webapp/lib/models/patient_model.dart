

class Patient {
  final String id;
  final String rut;
  final String nombre;
  final String prioridad;
  final String enfermedadesCronicas;
  final String alergias;
  final String status;

  Patient({
    required this.id,
    required this.rut,
    required this.nombre,
    required this.prioridad,
    required this.enfermedadesCronicas,
    required this.alergias,
    required this.status,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'].toString(),
      rut: json['rut'] ?? 'Sin RUT',
      nombre: json['nombre'] ?? 'Sin Nombre',
      prioridad: json['prioridad'] ?? 'Sin prioridad',
      enfermedadesCronicas: json['enfermedadesCronicas'] ?? 'Sin enfermedades cronicas',
      alergias: json['alergias'] ?? 'Sin alergias',
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
