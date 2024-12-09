class SolicitudEstado {
  String? doctorId;
  String? doctorNombre;
  String? horaSeleccionada;
  String? especialidadSeleccionada;
  int? patientId; // Nuevo campo para almacenar el ID del paciente

  // Constructor opcional
  SolicitudEstado({
    this.doctorId,
    this.doctorNombre,
    this.horaSeleccionada,
    this.especialidadSeleccionada,
    this.patientId, // Inicialización del patientId
  });

  // Generar resumen
  String generarResumen() {
    return "Resumen de tu solicitud: PatientId $patientId.";
  }

  // Reiniciar el estado cuando sea necesario
  void reiniciar() {
    doctorId = null;
    doctorNombre = null;
    horaSeleccionada = null;
    especialidadSeleccionada = null;
    // patientId = null; // Reinicia también el ID del paciente
  }
}
