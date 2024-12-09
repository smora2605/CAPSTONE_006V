import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mediconecta_webapp/utils/constants.dart';

class ApiServices {
  final _baseURL = Constants().baseURL;

  Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/usuarios'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer usuarios ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer usuarios $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<List<dynamic>> getUsersPatients() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/usuarios/tipoPacientes'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer usuarios ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer usuarios $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<List<dynamic>> getDoctors() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/doctores'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer doctores ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer doctores $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<List<dynamic>> getDoctorsNames() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/doctores/doctoresName'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer doctores ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer doctores $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<List<dynamic>> getPatients() async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/pacientes'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer pacientes ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer pacientes $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<Map<String, dynamic>> addUser({
    required String rut,
    required String nombre,
    required String email,
    required String telefono,
    required String fechaNacimiento,
    required String genero,
    required String tipoUsuario,
    required String password,
  }) async {
    
    try {
      // Cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'rut': rut,
        'nombre': nombre,
        'email': email,
        'telefono': telefono,
        'fechaNacimiento': fechaNacimiento,
        'genero': genero,
        'tipo_usuario': tipoUsuario,
        'password': password,
      };

      // Petición POST
      final response = await http.post(
        Uri.parse('$_baseURL/usuarios'),
        headers: {
          'Content-Type': 'application/json', // Indicamos que es un JSON
        },
        body: jsonEncode(body), // Convertimos el mapa a JSON
      );

      if (response.statusCode == 201) {
        // Usuario creado correctamente
        return jsonDecode(response.body); // Devolvemos los datos del nuevo usuario
      } else {
        print('Error al crear usuario: ${response.statusCode}');
        print('Error al crear usuario: ${response.body}');
        return {}; // Devolvemos un mapa vacío en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return {}; // En caso de excepción, devolvemos un mapa vacío
    }
  }

  Future<Map<String, dynamic>> addPatient({
    required int usuarioId,
    required String prioridad,
    required String enfermedadesCronicas,
    required String alergias,
    required String status,
  }) async {
    
    try {
      // Cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'usuarioId': usuarioId,
        'prioridad': prioridad,
        'enfermedadesCronicas': enfermedadesCronicas,
        'alergias': alergias,
        'status': status,
      };

      print('body $body');

      // Petición POST
      final response = await http.post(
        Uri.parse('$_baseURL/pacientes'),
        headers: {
          'Content-Type': 'application/json', // Indicamos que es un JSON
        },
        body: jsonEncode(body), // Convertimos el mapa a JSON
      );

      if (response.statusCode == 201) {
        // Usuario creado correctamente
        return jsonDecode(response.body); // Devolvemos los datos del nuevo usuario
      } else {
        print('Error al crear usuario: ${response.statusCode}');
        return {}; // Devolvemos un mapa vacío en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return {}; // En caso de excepción, devolvemos un mapa vacío
    }
  }

  Future<List<dynamic>> getAppointmentsPendingsByDoctor(int doctorId) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/citas/doctor/$doctorId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer citas ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer citas $e');
      return []; // En caso de excepción, devolvemos una lista vacía
    }
  }

  Future<List<dynamic>> getAppointmentsByDoctor(int doctorId) async {
    try {
      final response = await http.get(Uri.parse('$_baseURL/citas/doctorAll/$doctorId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data; // Devolvemos los datos decodificados
      } else {
        print('Algo ha ocurrido al traer citas ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error al traer citas $e');
      return []; // En caso de excepción, devolvemos una lista vacía
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
  Future<Map<String, dynamic>?> getDoctorByUserId(int userId) async {
    final response = await http.get(Uri.parse('$_baseURL/doctores/usuario/$userId'));

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

  Future<Map<String, dynamic>> crearFichaMedica({
    required int idCita,                // ID de la cita
    required int idPaciente,            // ID del paciente
    required int idDoctor,              // ID del doctor
    required String motivoConsulta,      // Motivo de la consulta
    required int peso,                // Peso en kg
    required int altura,              // Altura en cm
    required String presionArterial,     // Presión arterial (ej: "120/80")
    required int frecuenciaCardiaca,    // Frecuencia cardíaca en ppm
    required String examenFisico,        // Descripción del examen físico
    required String diagnostico,         // Diagnóstico del paciente
    required String tratamiento,         // Detalles del tratamiento
    // required String medicamento1,        // Descripción del medicamento 1
    // required int frecuenciaMedicamento1, // Frecuencia del medicamento 1
    // required int diasMedicamento1,      // Días del medicamento 1
    // required String medicamento2,        // Descripción del medicamento 2
    // required int frecuenciaMedicamento2, // Frecuencia del medicamento 2
    // required int diasMedicamento2,      // Días del medicamento 2
    // required String recordatorio,        // Descripción del recordatorio
    // required int frecuenciaRecordatorio, // Repetir cada cuántos días
    // required int diasRecordatorio        // Días del recordatorio
  }) async {
    try {
      // Cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'id_cita': idCita,
        'id_paciente': idPaciente,
        'id_doctor': idDoctor,
        'motivo_consulta': motivoConsulta,
        'peso': peso,
        'altura': altura,
        'presion_arterial': presionArterial,
        'frecuencia_cardiaca': frecuenciaCardiaca,
        'examen_fisico': examenFisico,
        'diagnostico': diagnostico,
        'tratamiento': tratamiento,
        // 'medicamento_1': medicamento1,
        // 'frecuencia_medicamento_1': frecuenciaMedicamento1,
        // 'dias_medicamento_1': diasMedicamento1,
        // 'medicamento_2': medicamento2,
        // 'frecuencia_medicamento_2': frecuenciaMedicamento2,
        // 'dias_medicamento_2': diasMedicamento2,
        // 'recordatorio': recordatorio,
        // 'frecuencia_recordatorio': frecuenciaRecordatorio,
        // 'dias_recordatorio': diasRecordatorio,
      };

      print('body $body');

      // Petición POST
      final response = await http.post(
        Uri.parse('$_baseURL/fichasMedicas'), // Cambia a la URL correcta de tu API
        headers: {
          'Content-Type': 'application/json', // Indicamos que es un JSON
        },
        body: jsonEncode(body), // Convertimos el mapa a JSON
      );

      if (response.statusCode == 201) {
        // Ficha médica creada correctamente
        return jsonDecode(response.body); // Devolvemos los datos de la nueva ficha médica
      } else {
        print('Error al crear ficha médica: ${response.statusCode}');
        return {}; // Devolvemos un mapa vacío en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return {}; // En caso de excepción, devolvemos un mapa vacío
    }
  }

  Future<Map<String, dynamic>> addAvailability({
    required int doctorId,
    required String fecha, // Formato YYYY-MM-DD
    required String horaInicio, // Formato HH:mm
    required String horaFin, // Formato HH:mm
  }) async {
    try {
      // Cuerpo de la solicitud
      final Map<String, dynamic> body = {
        'doctor_id': doctorId,
        'fecha': fecha,
        'hora_inicio': horaInicio,
        'hora_fin': horaFin,
      };

      print('body $body');

      // Petición POST
      final response = await http.post(
        Uri.parse('$_baseURL/disponibilidades'),
        headers: {
          'Content-Type': 'application/json', // Indicamos que es un JSON
        },
        body: jsonEncode(body), // Convertimos el mapa a JSON
      );

      if (response.statusCode == 201) {
        // Disponibilidad creada correctamente
        print('Disponibilidad añadida: ${response.body}');
        return jsonDecode(response.body); // Devolvemos los datos de la disponibilidad
      } else {
        print('Error al añadir disponibilidad: ${response.statusCode}');
        return {}; // Devolvemos un mapa vacío en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return {}; // En caso de excepción, devolvemos un mapa vacío
    }
  }

  Future<List<Map<String, dynamic>>> getAvailabilities() async {
    try {
      // Petición GET a la API
      final response = await http.get(
        Uri.parse('$_baseURL/disponibilidades'),
        headers: {
          'Content-Type': 'application/json', // Indicamos que esperamos un JSON
        },
      );

      if (response.statusCode == 200) {
        print('Disponibilidades recibidas: ${response.body}');
        // Decodificamos la respuesta JSON y la convertimos a una lista de mapas
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        print('Error al obtener disponibilidades: ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return []; // Devolvemos una lista vacía en caso de excepción
    }
  }

  Future<List<Map<String, dynamic>>> getAvailabilitiesByDate(String fecha) async {
    try {
      // Petición GET a la API con la fecha como parámetro en la URL
      final response = await http.get(
        Uri.parse('$_baseURL/disponibilidades/date/$fecha'),
        headers: {
          'Content-Type': 'application/json', // Indicamos que esperamos un JSON
        },
      );

      if (response.statusCode == 200) {
        print('Disponibilidades recibidas para la fecha $fecha: ${response.body}');
        // Decodificamos la respuesta JSON y la convertimos a una lista de mapas
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        print('Error al obtener disponibilidades: ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      return []; // Devolvemos una lista vacía en caso de excepción
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

  //Funcion para crear cita
  Future<List<Map<String, dynamic>>> createCita({
    required int pacienteId,
    required int doctorId,
    required DateTime fecha,
    required String hora,
    required String motivo,
    required String estado,
  }) async {
    try {      
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si la cita se creó correctamente
        var data = jsonDecode(response.body);

        // Verifica si el resultado es un mapa; si es así, envuélvelo en una lista
        if (data is Map<String, dynamic>) {
          return [data];
        } else if (data is List) {
          return data.map((item) => Map<String, dynamic>.from(item)).toList();
        } else {
          throw TypeError();
        }
      } else {
        print('Error al crear la cita: ${response.body}');
        return [];
      }
    } catch (e) {
      print('error al hacer la peticion de crear cita $e');
      // En caso de error, retorna una lista vacía
      return [];
    }
  }

  // Función para actualizar el estado de una cita
  Future<bool> updateCitaEstado({
    required int citaId,
    required String nuevoEstado,
  }) async {
    try {
      // Crear el cuerpo de la solicitud con los datos a actualizar
      final Map<String, dynamic> updateData = {
        'estado': nuevoEstado,
      };

      print('Actualizando cita $citaId con estado: $nuevoEstado');

      // Hacer la solicitud PATCH para actualizar el estado de la cita
      final response = await http.put(
        Uri.parse('$_baseURL/citas/$citaId'),
        headers: {'Content-Type': 'application/json'}, // Asegúrate de enviar JSON
        body: jsonEncode(updateData), // Convertir los datos a JSON
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Estado de la cita actualizado con éxito.');
        return true; // Devuelve `true` si la actualización fue exitosa
      } else {
        print('Error al actualizar el estado de la cita: ${response.body}');
        return false; // Devuelve `false` si hubo un error
      }
    } catch (e) {
      print('Error al hacer la petición para actualizar el estado de la cita: $e');
      return false; // Devuelve `false` en caso de error
    }
  }

  //Función para crear un recordatorio
  Future<Map<String, dynamic>?> createRecordatorio({
    required int pacienteId,
    required int doctorId,
    required int fichaMedicaId,
    required String descMedicamento,
    required int frecuencia,
    required int duracionDias,
  }) async {
    try {
      // Crear el cuerpo de la solicitud con los datos del recordatorio
      final Map<String, dynamic> recordatorioData = {
        'id_paciente': pacienteId,
        'id_doctor': doctorId,
        'id_ficha_medica': fichaMedicaId,
        'desc_medicamento': descMedicamento,
        'frecuencia': frecuencia,
        'duracion_dias': duracionDias,
      };

      print('recordatorioData $recordatorioData');

      // Hacer la solicitud POST para crear el recordatorio
      final response = await http.post(
        Uri.parse('$_baseURL/recordatorios/'),
        headers: {'Content-Type': 'application/json'}, // Asegúrate de enviar JSON
        body: jsonEncode(recordatorioData), // Convertir los datos a JSON
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si el recordatorio se creó correctamente
        var data = jsonDecode(response.body);
        print('Recordatorio creado exitosamente: $data');
        return data;
      } else {
        print('Error al crear el recordatorio: ${response.body}');
        return null; // Devuelve null en caso de error
      }
    } catch (e) {
      print('Error al hacer la petición para crear recordatorio: $e');
      return null; // Devuelve null en caso de excepción
    }
  }


}