

class Patient {
  final String id;
  final String nombre;

  Patient({
    required this.id,
    required this.nombre,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? 'Sin Nombre',
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
