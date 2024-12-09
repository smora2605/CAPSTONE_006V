import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/services/solicitud_estado.dart';
import 'package:provider/provider.dart';

class NLP {
  //Funciones para peticiones http
  final ApiService apiService = ApiService();
  // Estado de la solicitud actual
  SolicitudEstado estadoSolicitud = SolicitudEstado();

  // URL de la API de NLP en Collab
  final String apiUrl = "https://950d-34-82-190-61.ngrok-free.app/process_text/";

  String? lastResponse; // Variable para almacenar la última respuesta generada

  // Enviar `input_text` a la API de NLP en Colab y obtener intenciones y respuesta
  Future<Map<String, dynamic>> sendInputToNLP(String inputText) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"input_text": inputText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        print(data['response']);
        return {
          "intents": data['intents'],
          "response": data['response'],
        };
      } else {
        throw Exception("Error al procesar la solicitud: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud NLP: $e");
      return {
        "intents": ["intent_no_entendido"],
        "response": "Hubo un error al procesar tu solicitud.",
      };
    }
  }

  List<Map<String, String>> listaDoctores = [];
  List<dynamic> listaDisponibilidades = [];

  String normalizeText(String text) {
    const Map<String, String> accentMap = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'Á': 'A',
      'É': 'E',
      'Í': 'I',
      'Ó': 'O',
      'Ú': 'U',
      'ñ': 'n',
      'Ñ': 'N'
    };

    return text
        .toLowerCase() // Convertir a minúsculas
        .replaceAllMapped(RegExp('[áéíóúÁÉÍÓÚñÑ]'), (match) {
          return accentMap[match.group(0)!] ?? match.group(0)!; // Reemplazar acentos
        })
        .replaceAll(RegExp(r'[^\w\s]'), '') // Eliminar signos de puntuación
        .trim(); // Eliminar espacios adicionales
  }

  // Función para detectar el nombre del doctor en el input
  String? detectDoctorName(String input) {
    String normalizedInput = normalizeText(input);

    print('normalizedInput $normalizedInput');

    // Recorrer la lista de doctores para encontrar una coincidencia
    for (var doctor in listaDoctores) {
      String doctorName = normalizeText(doctor['nombre']!);
      print('normalizedInput $normalizedInput');
      if (normalizedInput.contains(doctorName)) {
        print("doctorid ${doctor['id']}");
        return doctor['id']; // Devolver el ID del doctor si se encuentra
      }
    }
    return null; // No se encontró ningún doctor
  }

  // Convierte frases comunes de horas a formato de 24 horas (por ejemplo, "10 y media" a "10:30")
  String? convertirFrasesComunesAHoras(String input) {
    // Expresiones regulares para diferentes formas de decir la hora
    final regexHoraConMinutos = RegExp(r'(\d{1,2}):(\d{2})');
    final regexSoloHora = RegExp(r'\b(\d{1,2})\b');
    final regexHoraYMedia = RegExp(r'(\d{1,2}) y media');

    // Función auxiliar para agregar un cero delante si la hora tiene solo un dígito
    String formatearHora(String horas, [String minutos = '00']) {
      if (horas.length == 1) {
        horas = '0$horas';  // Agregar "0" si la hora tiene solo un dígito
      }
      return '$horas:$minutos';
    }

    // "10:30", "10:00"
    if (regexHoraConMinutos.hasMatch(input)) {
      final match = regexHoraConMinutos.firstMatch(input)!;
      final horas = match.group(1)!;
      final minutos = match.group(2)!;
      return formatearHora(horas, minutos);
    }
    // "10 y media" -> "10:30"
    else if (regexHoraYMedia.hasMatch(input)) {
      final horas = regexHoraYMedia.firstMatch(input)!.group(1)!;
      return formatearHora(horas, '30');
    }
    // "10" -> "10:00"
    else if (regexSoloHora.hasMatch(input)) {
      final horas = regexSoloHora.firstMatch(input)!.group(0)!;
      return formatearHora(horas, '00');
    }

    return null; // Si no coincide con ningún formato de hora conocido
  }

  // Función para detectar si el usuario dice una hora que coincida con la lista de horas disponibles
  String? detectHora(String input) {
    String normalizedInput = input;
    print('listaDisponibilidades $listaDisponibilidades');


    print('normalizedInput $normalizedInput');

    // Convertir el input a un formato de hora
    String? horaUsuario = convertirFrasesComunesAHoras(normalizedInput);
    print('horaUsuario $horaUsuario');

    print('Hora extraída del input del usuario: $horaUsuario');

    if (horaUsuario != null) {
      bool horaEncontrada = false;
      // Recorrer la lista de disponibilidades para encontrar una coincidencia
      for (var dispo in listaDisponibilidades) {
        String horaDisponible = dispo['hora']!;
        print('dispo["hora"] $dispo');
        print('Comparando con hora disponible: $horaDisponible');
        print('listaDisponibilidades $listaDisponibilidades');

        if (horaUsuario == horaDisponible) {
          print("Hora encontrada: $horaDisponible");
          horaEncontrada = true; // Marcar que se ha encontrado la hora
          return horaDisponible;  // Devolver la hora si se encuentra
        }
      }

       // Si recorremos toda la lista y no encontramos la hora, mostrar mensaje de error
      if (!horaEncontrada) {
        print("La hora que has ingresado no parece estar disponible o quizás no tiene el formato adecuado.");
        return "La hora que has ingresado no parece estar disponible o quizás no tiene el formato adecuado.";
      }
    }

    return null; // No se encontró ninguna coincidencia
  }

  Future<Map<String, dynamic>> generateResponse(BuildContext context, String input) async {
    final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
    final nlpResult = await sendInputToNLP(input);  // Obtener intenciones y respuesta desde Colab
    String responseText = nlpResult['response'];
    List<String> detectedIntents = List<String>.from(nlpResult['intents']);
    List<String> responses = [];
    Map<String, dynamic> finalResponse = {};

     String? doctorNombre = '';
    String? doctorEspecialidad = '';

    String? horaEncontrada = detectHora(input); // Detecta la hora seleccionada
    String? doctorId = detectDoctorName(input);
    List<String>? horas = [];

    // Guardar la última respuesta generada si no es una intención de repetir
    if (!detectedIntents.contains("repetir")) {
      lastResponse = responseText;
    }

    // Si el usuario pide repetir, responder con la última respuesta generada
    if (detectedIntents.contains("repetir")) {
      responses.add(lastResponse ?? "Lo siento, no tengo nada para repetir en este momento.");
      finalResponse['formattedResponse'] = responses.join(" ");
      return finalResponse;
    }

    for (String intent in detectedIntents) {
      // Lógica para disponibilidad general
      if (intent == "consultar_disponibilidad_general") {
        DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadGeneral();
        listaDoctores = [];
        estadoSolicitud.reiniciar();

        if(apiResponse.rawData.isNotEmpty){
          listaDoctores = (apiResponse.rawData).map((item) {
            if (item is Map && item.containsKey('nombre') && item.containsKey('id')) {
              return {
                'nombre': item['nombre'].toString(),
                'id': item['id'].toString(),
                'especialidad': item['especialidad'].toString(),
              };
            } else {
              throw Exception("Formato inesperado en la respuesta de la API");
            }
          }).toList();

          String doctoresNombres = listaDoctores.map((d) => d['nombre']).join(", ");
          responses.add("Tenemos los siguientes doctores disponibles: $doctoresNombres.");
          responses.add("¿Con cuál doctor te gustaría agendar una cita?");
          finalResponse['rawData'] = apiResponse.rawData;
        } else {
          responses.add("Lo sentimos, no hay ningún doctor disponible hoy para la especialidad de medicina general.");
        }

      } else if (intent == "consultar_disponibilidad_cardiologia") {
        DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadCardiologia();
        listaDoctores = [];
        estadoSolicitud.reiniciar();

        listaDoctores = (apiResponse.rawData).map((item) {
          if (item is Map && item.containsKey('nombre') && item.containsKey('id')) {
            return {
              'nombre': item['nombre'].toString(),
              'id': item['id'].toString(),
              'especialidad': item['especialidad'].toString(),
            };
          } else {
            throw Exception("Formato inesperado en la respuesta de la API");
          }
        }).toList();

        if(listaDoctores.isNotEmpty){
          String doctoresNombres = listaDoctores.map((d) => d['nombre']).join(", ");
          responses.add("Tenemos los siguientes doctores disponibles: $doctoresNombres.");
          responses.add("¿Con cuál doctor te gustaría agendar una cita?");
          finalResponse['rawData'] = apiResponse.rawData;
        } else {
          responses.add("Lo siento, no tenemos doctores para cardiología disponibles.");
        }
      } else if (intent == "consultar_especialidades") {
        DisponibilidadResponse apiResponse = await apiService.fetchEspecialidades();
        responses.add(apiResponse.formattedResponse);
        finalResponse['rawData'] = apiResponse.rawData;
      } else if (doctorId != null) {
        List<dynamic> bloques = [{'turno': 'Mañana'}, {'turno': 'Tarde'}];
        DisponibilidadResponse apiResponse = DisponibilidadResponse(formattedResponse: 'Selecciona el bloque horario', rawData: bloques);

        doctorNombre = listaDoctores.firstWhere((d) => d['id'] == doctorId)['nombre'];
        doctorEspecialidad = listaDoctores.firstWhere((d) => d['id'] == doctorId)['especialidad'];
        estadoSolicitud.doctorId = doctorId;
        estadoSolicitud.doctorNombre = doctorNombre;
        estadoSolicitud.especialidadSeleccionada = doctorEspecialidad;
        finalResponse['rawData'] = apiResponse.rawData;
        responses.add(apiResponse.formattedResponse);

      } else if (intent == "seleccionar_bloquehorarioDia") {
        if (estadoSolicitud.doctorId != null) {
          estadoSolicitud.horaSeleccionada = horaEncontrada;

          DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadDiaDoctor(estadoSolicitud.doctorId!);
          listaDisponibilidades = (apiResponse.rawData).map((item) => item).toList();

          if(listaDisponibilidades.isNotEmpty){
            responses.add('Selecciona una de las siguientes horas disponibles.');
            finalResponse['rawData'] = apiResponse.rawData;
          } else {
            List<dynamic> bloques = [{'turno': 'Mañana'}, {'turno': 'Tarde'}];
            finalResponse['rawData'] = bloques;
            responses.add('Lo sentimos, no hay horas disponibles en la mañana.');
          }
          
        } else {
          responses.add('No has seleccionado un médico. Por favor, indica la especialidad que necesitas y luego selecciona al doctor.');
        }
      } else if (intent == "seleccionar_bloquehorarioTarde") {
        if (estadoSolicitud.doctorId != null) {
          estadoSolicitud.horaSeleccionada = horaEncontrada;

          DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadTardeDoctor(estadoSolicitud.doctorId!);
          listaDisponibilidades = (apiResponse.rawData).map((item) => item).toList();

          if(listaDisponibilidades.isNotEmpty){
            responses.add('Selecciona una de las siguientes horas disponibles.');
            finalResponse['rawData'] = apiResponse.rawData;
          } else {
            responses.add('Lo sentimos, no hay horas disponibles en la tarde.');
            finalResponse['rawData'] = apiResponse.rawData;
          }
        } else {
          responses.add('No has seleccionado un médico. Por favor, indica la especialidad que necesitas y luego selecciona al doctor.');
        }
      } else if (horaEncontrada != null) {
        if (listaDisponibilidades.any((dispo) => dispo['hora'] == horaEncontrada)) {
          estadoSolicitud.horaSeleccionada = horaEncontrada;

          final apiResponseSummary = [{
            'TipoResumen': true,
            'DoctorName': estadoSolicitud.doctorNombre,
            'Especialidad': estadoSolicitud.especialidadSeleccionada,
            'HoraSeleccionada': estadoSolicitud.horaSeleccionada,
            'Fecha': DateTime.now().toString(),
            'Estado' : 'Pendiente',
          }];

          responses.add("Revisa tu solicitud: estás agendando con ${estadoSolicitud.doctorNombre} a las ${estadoSolicitud.horaSeleccionada}. Di confirmar o presiona el botón para finalizar.");
          finalResponse['rawData'] = apiResponseSummary;
          print('apiResponse.rawData $apiResponseSummary');
        } else {
          finalResponse['rawData'] = listaDisponibilidades;
          responses.add("La hora que seleccionaste no está disponible. Por favor, selecciona una de las horas disponibles.");
        }
      } else if (intent == "confirmar") {
        if (estadoSolicitud.doctorId != null && estadoSolicitud.horaSeleccionada != null) {
          DisponibilidadResponse response = await apiService.createCita(
            pacienteId: userAuthProvider.patientId!,
            doctorId: int.parse(estadoSolicitud.doctorId!),
            fecha: DateTime.now(),
            hora: estadoSolicitud.horaSeleccionada!,
            motivo: 'Consulta de rutina',
            estado: 'Pendiente',
          );

          List<dynamic> success = [{'success': true}];

          responses.add("Se ha creado tu solicitud con éxito. Recuerda llegar 15 minutos antes de la cita.");
          finalResponse['rawData'] = success;
          estadoSolicitud.reiniciar();
        } else {
          responses.add("No has seleccionado una hora o un doctor válidos. Por favor, completa esta información.");
        }
      }
      break;
    }

    // Combina todas las respuestas y almacena la respuesta final
    finalResponse['formattedResponse'] = responses.join("");
    return finalResponse;
  }

}
