import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediconecta_app/utils/constants.dart';

class DisponibilidadResponse {
  final String formattedResponse;
  final List<dynamic> rawData;

  DisponibilidadResponse({required this.formattedResponse, required this.rawData});
}

class ApiService {
  final _baseURL = Constants().baseURL;

  // Función para realizar la petición fetch para disponibilidad general
  //Retorna un objeto con la respuesta y la data
  Future<DisponibilidadResponse> fetchDisponibilidadGeneral() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/doctores/doctoresMedicinaGeneral'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        print('data $data');

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
      final response = await http.get(Uri.parse('$_baseURL/doctores/doctoresCardiologia'));

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
      final response = await http.get(Uri.parse('$_baseURL/especialidades/'));

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
      final response = await http.get(Uri.parse('$_baseURL/disponibilidades/$idDoctor'));

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

  Future<DisponibilidadResponse> fetchDisponibilidadDiaDoctor(String idDoctor) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/disponibilidades/$idDoctor'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Generar las horas disponibles en intervalos de 15 minutos
        List<dynamic> horasDisponiblesMessage = [];
        List<dynamic> horasDisponibles = [];
        print('data $data');

        // Obtener la hora actual
        DateTime now = DateTime.now();

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

              // Ajustar horaInicio al momento actual si es necesario
              if (horaInicio.isBefore(now)) {
                horaInicio = DateTime(
                  1970, 01, 01, now.hour, (now.minute / 15).ceil() * 15
                );
                print('horaInicio $horaInicio');
              }

              while (horaInicio.isBefore(horaFin) || horaInicio.isAtSameMomentAs(horaFin)) {
                // Obtener la hora y minutos actuales de horaInicio
                int horasActual = horaInicio.hour;

                // Verificar si la hora actual está en el rango de 8:00 a 12:00
                if (horasActual >= 7 && horasActual <= 11) {
                  String horas = horaInicio.hour.toString().padLeft(2, '0');
                  String minutosMessage = horaInicio.minute == 0 ? "" : horaInicio.minute.toString().padLeft(2, '0');
                  String minutos = horaInicio.minute.toString().padLeft(2, '0');
                  
                  // Formatear la hora en el mensaje legible
                  horasDisponiblesMessage.add("- a las $horas${minutosMessage.isEmpty ? '' : ' con $minutosMessage'}");
                  
                  // Añadir un objeto con la hora y minutos a la lista de horasDisponibles
                  horasDisponibles.add({
                    "hora": "$horas:$minutos"
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

  Future<DisponibilidadResponse> fetchDisponibilidadTardeDoctor(String idDoctor) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/disponibilidades/$idDoctor'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // Generar las horas disponibles en intervalos de 15 minutos
        List<dynamic> horasDisponiblesMessage = [];
        List<dynamic> horasDisponibles = [];
        print('data $data');

        // Obtener la hora actual
        DateTime now = DateTime.now();

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

              // Ajustar horaInicio al momento actual si es necesario
              if (horaInicio.isBefore(now)) {
                horaInicio = DateTime(
                  1970, 01, 01, now.hour, (now.minute / 15).ceil() * 15
                );
                print('horaInicio $horaInicio');
              }

              while (horaInicio.isBefore(horaFin) || horaInicio.isAtSameMomentAs(horaFin)) {

                print('Entra?');
                // Obtener la hora y minutos actuales de horaInicio
                int horasActual = horaInicio.hour;

                // Verificar si la hora actual está en el rango de 12:00 a 20:00
                if (horasActual >= 12 && horasActual <= 20) {
                  String horas = horaInicio.hour.toString().padLeft(2, '0');
                  String minutosMessage = horaInicio.minute == 0 ? "" : horaInicio.minute.toString().padLeft(2, '0');
                  String minutos = horaInicio.minute.toString().padLeft(2, '0');
                  
                  // Formatear la hora en el mensaje legible
                  horasDisponiblesMessage.add("- a las $horas${minutosMessage.isEmpty ? '' : ' con $minutosMessage'}");
                  
                  // Añadir un objeto con la hora y minutos a la lista de horasDisponibles
                  horasDisponibles.add({
                    "hora": "$horas:$minutos"
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
        Uri.parse('$_baseURL/citas/'),
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

  Future<List<dynamic>> fetchAppointmentsPendingByPatient(int patientId) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/citas/pending/$patientId'));

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

  // Obtener los datos de un usuario por su ID
  Future<Map<String, dynamic>> getCurrentUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseURL/usuarios/$userId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los datos del usuario');
    }
  }

  // Verificar si un usuario es doctor por su userId
  Future<Map<String, dynamic>?> getPatientByUserId(int userId) async {
    final response = await http.get(Uri.parse('$_baseURL/pacientes/usuario/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> doctorData = jsonDecode(response.body); // Parsear la respuesta como lista

      if (doctorData.isNotEmpty) {
        return doctorData.first; // Devolver el primer elemento de la lista si existe
      } else {
        return null; // No hay doctores con ese userId
      }
    } else if (response.statusCode == 404) {
      return null; // No es un doctor
    } else {
      throw Exception('Error al verificar si el usuario es un doctor');
    }
  }

  // Función para obtener todos los registros de salud de un paciente
  Future<List<Map<String, dynamic>>> getRegistrosSalud(int pacienteId) async {
    try {
      print('Obteniendo registros de salud para el paciente con ID: $pacienteId');

      // Realizar la solicitud GET
      final response = await http.get(
        Uri.parse('$_baseURL/registro_salud/$pacienteId'), // Cambia esto a tu endpoint
        headers: {'Content-Type': 'application/json'},
      );

      print('response: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, decodificamos los datos
        List<dynamic> data = jsonDecode(response.body);
        return data.map((registro) => registro as Map<String, dynamic>).toList(); // Convertimos a List<Map<String, dynamic>>
      } else {
        print('Error al obtener registros de salud: ${response.statusCode}');
        return []; // Retornamos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al hacer la petición para obtener registros de salud: $e');
      return []; // Retornamos una lista vacía en caso de excepción
    }
  }

  // Función para crear un nuevo registro de salud
  Future<Map<String, dynamic>?> createRegistroSalud({
    required int pacienteId,
    int? nivelGlucosa,
    int? presionArterial,
    int? frecuenciaCardiaca,
  }) async {
    try {
      print('Creando registro de salud');

      // Cuerpo de la solicitud con los datos de salud
      final Map<String, dynamic> body = {
        'paciente_id': pacienteId,
        'nivel_glucosa': nivelGlucosa,
        'presion_arterial': presionArterial,
        'frecuencia_cardiaca': frecuenciaCardiaca,
      };

      print('registroData $body');

      // Realizar la solicitud POST para crear el registro
      final response = await http.post(
        Uri.parse('$_baseURL/registro_salud/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print('response $response');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si el registro se creó correctamente
        var data = jsonDecode(response.body);
        return data;
      } else {
        print('Error $response');
        // Si hubo un error en la solicitud
        return {};
      }
    } catch (e) {
      print('Error al hacer la petición para crear registro de salud $e');
      // En caso de error
      return {};
    }
  }

  // Obtener los datos de los recordatorios
  Future<List<dynamic>> getRecordatorios() async {
    final response = await http.get(Uri.parse('$_baseURL/recordatorios'));

    if (response.statusCode == 200) {
      print('responseRecordatorio ${response.body}');
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener los recordatorios');
    }
  }
}
