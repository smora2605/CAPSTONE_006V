import 'dart:math';

import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/services/solicitud_estado.dart';

class NLP {
  //Funciones para peticiones http
  final ApiService apiService = ApiService();
  // Estado de la solicitud actual
  SolicitudEstado estadoSolicitud = SolicitudEstado();

  // Dataset de intenciones y patrones
  final List<Map<String, dynamic>> intentData = [
    {
      "intent": "saludo",
      "patterns": [
        "Hola",
        "Buenos días",
        "Buenas tardes",
        "Qué tal",
        "Hola asistente"
      ],
      "responses": [
        "Hola, muy buen día.",
        "¡Hola!",
      ]
    },
    {
      "intent": "consultar_disponibilidad_general",
      "patterns": [
        "¿Qué días tienen disponibilidad para medicina general?",
        "¿Qué doctores tienen disponibles para medicina general?",
        "¿Tienen disponidibilidad para medicina general?",
        "Disponibilidad para medicina general",
        "disponibilidades para medicina general",
        "disponibilidad tienen para medicina general",
        "medicina general",
        "consulta general",
      ],
      "responses": [
        "Si tenemos disponibilidad de lunes a viernes, ¿Qué especialidad requiere?",
      ]
    },
    {
      "intent": "consultar_disponibilidad_cardiologia",
      "patterns": [
        "¿Qué días tienen disponibilidad para cardiología?",
        "¿Qué doctores tienen disponibles para cardiología?",
        "¿Tienen disponidibilidad para cardiología?",
        "Disponibilidad para cardiología",
        "disponibilidades para cardiología",
        "disponibilidad tienen para cardiología",
        "cardiología",
        "doctor que ve las enfermedades del corazón",
        "enfermedades del corazón",
      ],
      "responses": [
        "Si tenemos disponibilidad de lunes a viernes, ¿Qué especialidad requiere?",
      ]
    },
    {
      "intent": "seleccionar_doctor",
      "patterns": [
        "Quiero agendar con el",
        "Quiero consultar disponibilidad de",
        "Me interesa agendar con la",
        "Disponibilidad del",
        "Que disponibilidad tiene"
      ],
      "responses": [
        "El doctor tiene las siguientes horas disponibles: Lunes de las 10 a las 15 horas, martes de 10:30 a 14 horas. ¿Te gustaría agendar en uno de estos horarios?"
      ]
    },
    {
      "intent": "seleccionar_bloquehorarioDia",
      "patterns": [
        "mañana",
        "día",
      ],
      "responses": [
        "Este es el bloque horario disponible en la mañana para el doctor."
      ]
    },
    {
      "intent": "seleccionar_bloquehorarioTarde",
      "patterns": [
        "tarde",
      ],
      "responses": [
        "Este es el bloque horario disponible en la tarde para el doctor."
      ]
    },
    {
      "intent": "seleccionar_hora",
      "patterns": [
        "a las",
        "a la hora",
      ],
      "responses": [
        "Excelente, tu aquí tienes un resumen de tu solicitud. Di confirmar para crear la cita."
      ]
    },
    {
      "intent": "consultar_disponibilidad_por_dia",
      "patterns": [
        "¿Disponibilidad para el día lunes?",
        "¿Disponibilidad para el día martes?",
        "Horarios para el día lunes"
      ],
      "responses": [
        "El Dr. Pérez está disponible el lunes a las 10 am.",
        "El Dr. González tiene horarios disponibles el miércoles a las 3 pm."
      ]
    },
    {
      "intent": "reservar_cita",
      "patterns": [
        "Quiero reservar una cita",
        "Necesito una cita",
        "Agendar una cita",
        "Reservar hora",
        "Quiero agendar una consulta"
      ],
      "responses": [
        "¿Con qué doctor te gustaría agendar la cita?",
        "¿En qué fecha y hora te gustaría reservar?"
      ]
    },
    {
      "intent": "consultar_doctor",
      "patterns": [
        "¿Quién es el doctor?",
        "Quiero información sobre el doctor",
        "Dime algo sobre el Dr. Pérez",
        "¿Cuáles son las especialidades del doctor?",
        "Información del doctor"
      ],
      "responses": [
        "El Dr. Pérez es especialista en cardiología con 20 años de experiencia.",
        "El Dr. González se especializa en neurología y ha trabajado en este hospital por 15 años."
      ]
    },
    {
      "intent": "define_doctor",
      "patterns": [
        "¿Qué horas tiene disponible el doctor?",
      ],
      "responses": [
        "El doctor tiene las siguientes horas disponibles: Lunes de las 10 a las 15 horas, martes de 10:30 a 14 horas, miercoles de 14 a 18 horas.",
      ]
    },
    {
      "intent": "consultar_especialidades",
      "patterns": [
        "¿Qué especialidades tienen?",
        "¿Cuáles son las especialidades disponibles?",
        "Especialidades médicas",
        "Quiero saber sobre las especialidades",
        "¿Qué especialidades ofrecen?",
      ],
      "responses": [
        "Tenemos cardiología, neurología y pediatría disponibles.",
        "Las especialidades disponibles son dermatología, endocrinología y psiquiatría."
      ]
    },
    {
      "intent": "despedida",
      "patterns": [
        "Adiós",
        "Hasta luego",
        "Nos vemos",
        "Chao",
        "Gracias, eso es todo"
      ],
      "responses": [
        "¡Hasta luego! Cuídate.",
        "Adiós, que tengas un buen día.",
        "Nos vemos pronto."
      ]
    },
    {
      "intent": "agradecimiento",
      "patterns": [
        "Gracias",
        "Muchas gracias",
        "Te lo agradezco",
        "Agradecido",
        "Muy amable"
      ],
      "responses": [
        "¡De nada! Estoy aquí para ayudarte.",
        "Siempre a tu servicio.",
        "Es un placer ayudarte."
      ]
    },
    {
      "intent": "recordatorio_medicamento",
      "patterns": [
        "Recordatorio de medicamento",
        "Recuerda tomar el medicamento",
        "¿A qué hora debo tomar mi medicina?",
        "Medicamento",
        "Recordatorio de pastillas"
      ],
      "responses": [
        "Recuerda tomar tu paracetamol a las 8 pm.",
        "No olvides tu medicación diaria de insulina a las 7 am."
      ]
    },
    {
      "intent": "consulta_glucosa",
      "patterns": [
        "Quiero registrar mi nivel de glucosa",
        "Mi glucosa está en",
        "Registrar nivel de glucosa",
        "Mi glicemia es",
        "Tengo un nivel de glucosa de"
      ],
      "responses": [
        "Tu nivel de glucosa ha sido registrado.",
        "Hemos registrado tu glucosa en el sistema."
      ]
    },
    {
      "intent": "confirmar",
      "patterns": [
        "Quiero confirmar la hora con el doctor",
        "Quiero agendar mi hora",
        "Me gustaría confirmar la hora",
        "confirmar"
      ],
      "responses": [
        "Excelente, tu hora ha sido agendada con éxito. Recuerda llegar 15 minutos antes de la hora mencionada.",
      ]
    },
    {
      "intent": "intent_no_entendido",
      "patterns": [],
      "responses": [
        "No he podido entender tu solicitud, por favor se más claro.",
      ]
    }
  ];

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

  // Función para evaluar las intenciones del usuario
  List<String> evaluateIntents(String input) {
    String normalizedInput = normalizeText(input); // Normalizar la entrada
    print('input $input');
    print('normalizedInput $normalizedInput');

    List<String> detectedIntents = [];
    for (var intent in intentData) {
      for (var pattern in intent["patterns"]) {
        String normalizedPattern = normalizeText(pattern); // Normalizar el patrón
        if (normalizedInput.contains(normalizedPattern)) {
          print('------------');
          print('input $input');
          print('intent ${intent["intent"]}');
          print('-------------');
          detectedIntents.add(intent["intent"]);
          break;
        }
      }
    }
    return detectedIntents.isNotEmpty ? detectedIntents : ["intent_no_entendido"];
  }

  // Función para generar una respuesta en base a las intenciones
  Future<Map<String, dynamic>> generateResponse(String input) async {
    List<String> intents = evaluateIntents(input);
    List<String> responses = [];
    Map<String, dynamic> finalResponse = {};

    String? doctorNombre = '';
    String? doctorEspecialidad = '';
    String? horaEncontrada = '';
    print('horaEncontrada1 $horaEncontrada');

    String? doctorId = detectDoctorName(input);
    horaEncontrada = detectHora(input);
    print('horaEncontrada2 $horaEncontrada');


    for (String intent in intents) {
      for (var intentItem in intentData) {
        if (intentItem["intent"] == intent) {
          // Verificar si la intención es consultar disponibilidad general
          if (intents.contains("consultar_disponibilidad_general")) {
            // Llamar a la API para obtener la disponibilidad general, que incluye la lista de doctores
            DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadGeneral();

            listaDoctores = [];
            estadoSolicitud.reiniciar();

            if(apiResponse.rawData.isNotEmpty){
              // Actualizar la lista de doctores con la respuesta de la API
              listaDoctores = (apiResponse.rawData).map((item) {
                // Verificar que el item sea de tipo Map y que tenga las claves esperadas
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

              // Generar la lista de nombres de doctores para la respuesta
              String doctoresNombres = listaDoctores.map((d) => d['nombre']).join(", ");
              responses.add("Tenemos los siguientes doctores disponibles: $doctoresNombres.");
              responses.add("¿Con cuál doctor te gustaría agendar una cita?");

              finalResponse['rawData'] = apiResponse.rawData;
            }else{
              responses.add("Lo sentimos, no hay ningún doctor disponible hoy para la especialidad de medicina general.");
            }

            
          } else if (intents.contains("consultar_disponibilidad_cardiologia")) {
            // Llamar a la API para obtener la disponibilidad general, que incluye la lista de doctores
            DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadCardiologia();

            listaDoctores = [];
            estadoSolicitud.reiniciar();
            // Actualizar la lista de doctores con la respuesta de la API
            listaDoctores = (apiResponse.rawData).map((item) {
              // Verificar que el item sea de tipo Map y que tenga las claves esperadas
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

            // Generar la lista de nombres de doctores para la respuesta
            if(listaDoctores.isNotEmpty){

              String doctoresNombres = listaDoctores.map((d) => d['nombre']).join(", ");
              responses.add("Tenemos los siguientes doctores disponibles: $doctoresNombres.");
              responses.add("¿Con cuál doctor te gustaría agendar una cita?");
              finalResponse['rawData'] = apiResponse.rawData;
            }else{
              responses.add("Lo siento no tenermos doctores para cardiología disponibles.");
            }
          } else if (intent == "consultar_especialidades") {
            // Llamada directa a la API dentro de la función
            DisponibilidadResponse apiResponse = await apiService.fetchEspecialidades();
            responses.add(apiResponse.formattedResponse);

            // Almacena también los datos crudos si se necesitan
            finalResponse['rawData'] = apiResponse.rawData;
            //DOCTOR ID
          } else if (doctorId != null) {
            List<dynamic> bloques = [{'turno': 'Mañana'}, {'turno': 'Tarde'}];
            // Verificar si el usuario selecciona un doctor
            // Si el usuario mencionó un doctor, buscar su disponibilidad por ID
            // DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadDoctor(doctorId);
            DisponibilidadResponse apiResponse = DisponibilidadResponse(formattedResponse: 'Selecciona el bloque horario', rawData: bloques);

            print('listaDoctores $listaDoctores');

            doctorNombre = listaDoctores.firstWhere((d) => d['id'] == doctorId)['nombre'];
            doctorEspecialidad = listaDoctores.firstWhere((d) => d['id'] == doctorId)['especialidad'];
            estadoSolicitud.doctorId = doctorId;
            estadoSolicitud.doctorNombre = doctorNombre;
            estadoSolicitud.especialidadSeleccionada = doctorEspecialidad;
            finalResponse['rawData'] = apiResponse.rawData;
            responses.add(apiResponse.formattedResponse);

            

            // if(listaDisponibilidades.isEmpty){
            //   responses.add('Lo siento, el doctor ${estadoSolicitud.doctorNombre} no tiene horarios disponibles para hoy.');
            // }else{
            //   // responses.add("Disponibilidad de $doctorNombre: ${apiResponse.formattedResponse}");
            //   finalResponse['rawData'] = apiResponse.rawData;
            // }

            
          } // Selecciona bloque horario día
          else if (intents.contains("seleccionar_bloquehorarioDia")) {
            if (estadoSolicitud.doctorId != null) {
              estadoSolicitud.horaSeleccionada = horaEncontrada;

              DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadDiaDoctor(estadoSolicitud.doctorId!);
              listaDisponibilidades = (apiResponse.rawData).map((item) {
                return item;
              }).toList();

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
          }// Selecciona bloque horario tarde
          else if (intents.contains("seleccionar_bloquehorarioTarde")) {
            if (estadoSolicitud.doctorId != null) {
              estadoSolicitud.horaSeleccionada = horaEncontrada;

              DisponibilidadResponse apiResponse = await apiService.fetchDisponibilidadTardeDoctor(estadoSolicitud.doctorId!);
              listaDisponibilidades = (apiResponse.rawData).map((item) {
                return item;
              }).toList();

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
          }
          //HORA SELECCIONADA
          else if (horaEncontrada != null) {
            if (estadoSolicitud.doctorId != null) {
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
              responses.add('No has seleccionado un médico. Por favor, indica la especialidad que necesitas y luego selecciona al doctor.');
            }
          } else if (intents.contains("confirmar")) {
            print('entrar?');
            print('estadoSolicitud.doctorId ${estadoSolicitud.doctorId}');
            print('estadoSolicitud.horaSeleccionada ${estadoSolicitud.horaSeleccionada}');
            if (estadoSolicitud.doctorId != null && estadoSolicitud.horaSeleccionada != null) {

              DisponibilidadResponse response = await apiService.createCita(
                pacienteId: 1, // ID del paciente
                doctorId: int.parse(estadoSolicitud.doctorId!), // ID del doctor
                fecha: DateTime.now(), // Fecha y hora de la cita
                hora: estadoSolicitud.horaSeleccionada!,
                motivo: 'Consulta de rutina',
                estado: 'Pendiente',
              );

              List<dynamic> success = [{'success': true}];

              responses.add("Se ha creado tú solicitud con éxito. Recuerda llegar 15 minutos antes de la hora de la cita.");
              finalResponse['rawData'] = success;
              estadoSolicitud.reiniciar();

            } else {
              responses.add('No has seleccionado un médico. Por favor, indica la especialidad que necesitas y luego selecciona al doctor para poder reservar una hora.');
            }
          }
          else {
            responses.add(intentItem["responses"][
                Random().nextInt((intentItem["responses"] as List).length)]);
            estadoSolicitud.reiniciar();
          }
          break;
        }
      }
    }

    // Combinar todas las respuestas
    finalResponse['formattedResponse'] = responses.join(" ");
    return finalResponse;
  }
}
