import 'dart:convert';

import 'package:http/http.dart' as http;

class DisponibilidadResponse {
  final String formattedResponse;
  final List<dynamic> rawData;

  DisponibilidadResponse({required this.formattedResponse, required this.rawData});
}

class ApiService {
  final String _baseUrl = 'http://192.168.175.20:3000/api';

  // Función para realizar la petición fetch para disponibilidad general
  //Retorna un objeto con la respuesta y la data
  Future<DisponibilidadResponse> fetchDisponibilidadGeneral() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/doctores/doctoresMedicinaGeneral'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Construir la lista de doctores y especialidades
        String doctorsList = data.map((doctor) {
          return "- ${doctor['nombre']} (${doctor['especialidad']})";
        }).join("\n");

        // Retornar la respuesta formateada y la data cruda
        return DisponibilidadResponse(
          formattedResponse: "Para medicina general tenemos disponible a:\n$doctorsList",
          rawData: data,
        );
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no pude obtener la disponibilidad general.",
          rawData: [],
        );
      }
    } catch (e) {
        print('$e');
        return DisponibilidadResponse(
          formattedResponse: "Error al realizar la solicitud: $e",
          rawData: [],
        );
    }
  }

  Future<DisponibilidadResponse> fetchDisponibilidadCardiologia() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/doctores/doctoresCardiologia'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Construir la lista de doctores y especialidades
        String doctorsList = data.map((doctor) {
          return "- ${doctor['nombre']} (${doctor['especialidad']})";
        }).join("\n");

        // Retornar la respuesta formateada y la data cruda
        return DisponibilidadResponse(
          formattedResponse: "Para cardiología tenemos disponible a:\n$doctorsList",
          rawData: data,
        );
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no pude obtener la disponibilidad general.",
          rawData: [],
        );
      }
    } catch (e) {
        print('$e');
        return DisponibilidadResponse(
          formattedResponse: "Error al realizar la solicitud: $e",
          rawData: [],
        );
    }
  }

  // Función para realizar la petición fetch para especialidades
  Future<DisponibilidadResponse> fetchEspecialidades() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/especialidades/'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Construir la lista de doctores y especialidades
        String especialidadList = data.map((especialidad) {
          return "- ${especialidad['nombre']}";
        }).join("\n");

        // Retornar la respuesta formateada y la data cruda
        return DisponibilidadResponse(
          formattedResponse: "Las especialidades que tenemos disponibles son:\n$especialidadList",
          rawData: data,
        );
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no hay especialidades disponibles.",
          rawData: [],
        );
      }
    } catch (e) {
      return DisponibilidadResponse(
        formattedResponse: "Error al realizar la solicitud: $e",
        rawData: [],
      );
    }
  }

  // Función para realizar la petición fetch para disponibilidades por doctor
  Future<DisponibilidadResponse> fetchDisponibilidadDoctor(String idDoctor) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/disponibilidades/$idDoctor'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Generar las horas disponibles en intervalos de 15 minutos
        List<dynamic> horasDisponiblesMessage = [];
        List<dynamic> horasDisponibles = [];
        print('data $data');

        // Verificar si data está vacío
        if (data.isNotEmpty) {
          String disponibilidadList = data.map((dispo) {
            // Obtener la fecha y la hora de inicio y fin
            String horaInicioStr = dispo['hora_inicio']; // Hora en formato HH:mm:ss
            String horaFinStr = dispo['hora_fin']; // Hora en formato HH:mm:ss

            try {
              // Parsear hora_inicio y hora_fin
              DateTime horaInicio = DateTime.parse('1970-01-01 $horaInicioStr');
              DateTime horaFin = DateTime.parse('1970-01-01 $horaFinStr');

              
              while (horaInicio.isBefore(horaFin) || horaInicio.isAtSameMomentAs(horaFin)) {
                String horas = horaInicio.hour.toString().padLeft(2, '0');
                String minutosMessage = horaInicio.minute == 0 ? "" : horaInicio.minute.toString().padLeft(2, '0');
                String minutos = horaInicio.minute.toString().padLeft(2, '0');
                
                // Formatear la hora en el mensaje legible
                horasDisponiblesMessage.add("- a las $horas${minutosMessage.isEmpty ? '' : ' con $minutosMessage'}");
                
                // Añadir un objeto con la hora y minutos a la lista de horasDisponibles
                horasDisponibles.add({
                  "hora":"$horas:$minutos"
                });
                
                // Incrementar por 15 minutos
                horaInicio = horaInicio.add(const Duration(minutes: 15));
              }

              // Devolver todas las horas formateadas
              return horasDisponiblesMessage.join("\n");
            } catch (e) {
              print("Error al formatear la fecha/hora: $e");
              return "- Formato de fecha u hora inválido";
            }
          }).join("\n");
          
          return DisponibilidadResponse(
            formattedResponse: "Para el día de hoy, los horarios disponibles son:\n$disponibilidadList",
            rawData: horasDisponibles,
          );
        } else {
          // Si no hay datos, retornar un mensaje diferente
          return DisponibilidadResponse(
            formattedResponse: "Lo sentimos, no hay horarios disponibles en este momento.",
            rawData: [],
          );
        }
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no hay horas disponibles con este doctor.",
          rawData: [],
        );
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return DisponibilidadResponse(
        formattedResponse: "Error al realizar la solicitud: $e",
        rawData: [],
      );
    }
  }

  // Función para realizar la petición fetch para disponibilidades por doctor
  Future<DisponibilidadResponse> fetchDisponibilidadDiaDoctor(String idDoctor) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/disponibilidades/$idDoctor'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Generar las horas disponibles en intervalos de 15 minutos
        List<dynamic> horasDisponiblesMessage = [];
        List<dynamic> horasDisponibles = [];
        print('data $data');

        // Verificar si data está vacío
        if (data.isNotEmpty) {
          String disponibilidadList = data.map((dispo) {
            // Obtener la fecha y la hora de inicio y fin
            String horaInicioStr = dispo['hora_inicio']; // Hora en formato HH:mm:ss
            String horaFinStr = dispo['hora_fin']; // Hora en formato HH:mm:ss

            try {
              // Parsear hora_inicio y hora_fin
              DateTime horaInicio = DateTime.parse('1970-01-01 $horaInicioStr');
              DateTime horaFin = DateTime.parse('1970-01-01 $horaFinStr');

              
              while (horaInicio.isBefore(horaFin) || horaInicio.isAtSameMomentAs(horaFin)) {
                // Obtener la hora y minutos actuales de horaInicio
                int horasActual = horaInicio.hour;
                print('horasActual $horasActual');
                
                // Verificar si la hora actual está en el rango de 8:00 a 12:00
                if (horasActual >= 8 && horasActual <= 11) {
                  String horas = horaInicio.hour.toString().padLeft(2, '0');
                  String minutosMessage = horaInicio.minute == 0 ? "" : horaInicio.minute.toString().padLeft(2, '0');
                  String minutos = horaInicio.minute.toString().padLeft(2, '0');
                              
                  // Formatear la hora en el mensaje legible
                  horasDisponiblesMessage.add("- a las $horas${minutosMessage.isEmpty ? '' : ' con $minutosMessage'}");
                              
                  // Añadir un objeto con la hora y minutos a la lista de horasDisponibles
                  horasDisponibles.add({
                    "hora":"$horas:$minutos"
                  });
                }

                // Incrementar por 15 minutos
                horaInicio = horaInicio.add(const Duration(minutes: 15));
              }


              // Devolver todas las horas formateadas
              return horasDisponiblesMessage.join("\n");
            } catch (e) {
              print("Error al formatear la fecha/hora: $e");
              return "- Formato de fecha u hora inválido";
            }
          }).join("\n");
          
          return DisponibilidadResponse(
            formattedResponse: "Para el día de hoy, los horarios disponibles son:\n$disponibilidadList",
            rawData: horasDisponibles,
          );
        } else {
          // Si no hay datos, retornar un mensaje diferente
          return DisponibilidadResponse(
            formattedResponse: "Lo sentimos, no hay horarios disponibles en este momento.",
            rawData: [],
          );
        }
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no hay horas disponibles con este doctor.",
          rawData: [],
        );
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return DisponibilidadResponse(
        formattedResponse: "Error al realizar la solicitud: $e",
        rawData: [],
      );
    }
  }

  // Función para realizar la petición fetch para disponibilidades por doctor
  Future<DisponibilidadResponse> fetchDisponibilidadTardeDoctor(String idDoctor) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/disponibilidades/$idDoctor'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Generar las horas disponibles en intervalos de 15 minutos
        List<dynamic> horasDisponiblesMessage = [];
        List<dynamic> horasDisponibles = [];
        print('data $data');

        // Verificar si data está vacío
        if (data.isNotEmpty) {
          String disponibilidadList = data.map((dispo) {
            // Obtener la fecha y la hora de inicio y fin
            String horaInicioStr = dispo['hora_inicio']; // Hora en formato HH:mm:ss
            String horaFinStr = dispo['hora_fin']; // Hora en formato HH:mm:ss

            try {
              // Parsear hora_inicio y hora_fin
              DateTime horaInicio = DateTime.parse('1970-01-01 $horaInicioStr');
              DateTime horaFin = DateTime.parse('1970-01-01 $horaFinStr');

              
              while (horaInicio.isBefore(horaFin) || horaInicio.isAtSameMomentAs(horaFin)) {
                // Obtener la hora y minutos actuales de horaInicio
                int horasActual = horaInicio.hour;
                print('horasActual $horasActual');
                
                // Verificar si la hora actual está en el rango de 8:00 a 12:00
                if (horasActual >= 12 && horasActual <= 20) {
                  String horas = horaInicio.hour.toString().padLeft(2, '0');
                  String minutosMessage = horaInicio.minute == 0 ? "" : horaInicio.minute.toString().padLeft(2, '0');
                  String minutos = horaInicio.minute.toString().padLeft(2, '0');
                              
                  // Formatear la hora en el mensaje legible
                  horasDisponiblesMessage.add("- a las $horas${minutosMessage.isEmpty ? '' : ' con $minutosMessage'}");
                              
                  // Añadir un objeto con la hora y minutos a la lista de horasDisponibles
                  horasDisponibles.add({
                    "hora":"$horas:$minutos"
                  });
                }

                // Incrementar por 15 minutos
                horaInicio = horaInicio.add(const Duration(minutes: 15));
              }

              // Devolver todas las horas formateadas
              return horasDisponiblesMessage.join("\n");
            } catch (e) {
              print("Error al formatear la fecha/hora: $e");
              return "- Formato de fecha u hora inválido";
            }
          }).join("\n");
          
          return DisponibilidadResponse(
            formattedResponse: "Para el día de hoy, los horarios disponibles son:\n$disponibilidadList",
            rawData: horasDisponibles,
          );
        } else {
          // Si no hay datos, retornar un mensaje diferente
          return DisponibilidadResponse(
            formattedResponse: "Lo sentimos, no hay horarios disponibles en este momento.",
            rawData: [],
          );
        }
      } else {
        return DisponibilidadResponse(
          formattedResponse: "Lo siento, no hay horas disponibles con este doctor.",
          rawData: [],
        );
      }
    } catch (e) {
      print('Error al realizar la solicitud: $e');
      return DisponibilidadResponse(
        formattedResponse: "Error al realizar la solicitud: $e",
        rawData: [],
      );
    }
  }

  // Función para crear una nueva cita
  Future<DisponibilidadResponse> createCita({
    required int pacienteId,
    required int doctorId,
    required DateTime fecha,
    required String hora,
    required String motivo,
    required String estado,
  }) async {
    try {
      print('CreandoCITA');
      
      // Crear el cuerpo de la solicitud con los datos de la cita
      final Map<String, dynamic> citaData = {
        'paciente_id': pacienteId,
        'doctor_id': doctorId,
        'fecha': fecha.toIso8601String(),
        'hora': hora,
        'motivo': motivo,
        'estado': estado,
      };

        print('citaData $citaData');


      // Hacer la solicitud POST para crear la cita
      final response = await http.post(
        Uri.parse('$_baseUrl/citas/'),
        headers: {'Content-Type': 'application/json'}, // Asegúrate de enviar JSON
        body: jsonEncode(citaData), // Convertir los datos a JSON
      );

      print('response $response');


      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Error $response');

        // Si la cita se creó correctamente
        var data = jsonDecode(response.body);
        return DisponibilidadResponse(
          formattedResponse: "Cita creada exitosamente para el ${data['fecha']}.",
          rawData: data,
        );
      } else {
        print('Error $response');
        // Si hubo un error en la solicitud
        return DisponibilidadResponse(
          formattedResponse: "Error al crear la cita. Código de estado: ${response.statusCode}.",
          rawData: [],
        );
      }
    } catch (e) {
      print('error al hacer la peticion de crear cita $e');
      // En caso de error
      return DisponibilidadResponse(
        formattedResponse: "Error al crear la cita: $e",
        rawData: [],
      );
    }
  }

  Future<List<dynamic>> fetchAppointmentsPending() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/citas/pending'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Devolver la data si la respuesta fue exitosa
        return data;
      } else {
        print('Algo ha ocurrido intentando obtener los elementos de citas pendientes ${response.statusCode}');
        // Devolver una lista vacía si hay un error en el código de estado
        return [];
      }
    } catch (e) {
      print('Error: $e');
      // Devolver una lista vacía en caso de excepción
      return [];
    }
  }

}
