import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  final String _baseUrl = 'http://192.168.175.20:3000/api';

  Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/usuarios'));

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
      final response = await http.get(Uri.parse('$_baseUrl/doctores'));

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
      final response = await http.get(Uri.parse('$_baseUrl/pacientes'));

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
}