class SolicitudEstado {
  String? doctorId;
  String? doctorNombre;
  String? horaSeleccionada;
  String? especialidadSeleccionada;

  // Constructor opcional
  SolicitudEstado({
    this.doctorId,
    this.doctorNombre,
    this.horaSeleccionada,
    this.especialidadSeleccionada,
  });

  // Generar resumen
  String generarResumen() {
    if (doctorNombre != null && horaSeleccionada != null) {
      return "Resumen de tu solicitud: Doctor/a: $doctorNombre, Hora: $horaSeleccionada.";
    } else if (doctorNombre != null) {
      return "Resumen de tu solicitud: Doctor/a: $doctorNombre, Hora: aún no seleccionada.";
    } else {
      return "Aún no has seleccionado un doctor/a ni una hora.";
    }
  }

  // Reiniciar el estado cuando sea necesario
  void reiniciar() {
    doctorId = null;
    doctorNombre = null;
    horaSeleccionada = null;
    especialidadSeleccionada = null;
  }
}