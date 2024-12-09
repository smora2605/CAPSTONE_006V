import 'dart:convert'; // Para manejar JSON

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart'; // Para decodificar JWT
import 'package:mediconecta_webapp/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuthProvider with ChangeNotifier {
  String? _token; // Token JWT
  bool _isAuthenticated = false;
  int? _userId; // ID del usuario
  int? _patientId; // ID del paciente
  Map<String, dynamic>? _currentUser; // Datos del usuario actual

  bool get isAuthenticated => _isAuthenticated;
  int? get userId => _userId;
  int? get patientId => _patientId;
  Map<String, dynamic>? get currentUser => _currentUser; // Getter del usuario actual

  final String _baseURL = Constants().baseURL;

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseURL/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];

        // Decodificar token para obtener el ID del usuario
        Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
        _userId = decodedToken['id'];

        // Guardar token y ID localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);

        _isAuthenticated = true;

        // Cargar los datos del paciente y del usuario actual
        await _fetchPatientId();
        await _fetchCurrentUser();

        notifyListeners();
      } else if (response.statusCode == 401) {
        throw Exception('Credenciales incorrectas.');
      } else {
        throw Exception('Error en el servidor. Inténtalo de nuevo más tarde.');
      }
    } catch (error) {
      rethrow;
    }
  }

  // Obtener el ID del paciente
  Future<void> _fetchPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    _patientId = prefs.getInt('patientId'); // Verificar si ya está en caché

    if (_patientId != null) {
      print('Paciente ID cargado desde cache: $_patientId');
      return; // Si ya está en memoria, no hace falta llamar a la API
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseURL/pacientes/usuario/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty && data[0].containsKey('id')) {
          _patientId = data[0]['id'];
          await prefs.setInt('patientId', _patientId!); // Guardar en caché
        } else {
          print('No se encontró un paciente para el usuario con ID: $_userId');
        }
      } else {
        throw Exception('Error al obtener el ID del paciente.');
      }
    } catch (error) {
      print('Error al buscar el ID del paciente: $error');
      rethrow;
    }
  }

  // Obtener los datos del usuario actual por ID
  Future<void> _fetchCurrentUser() async {
    print('_userId $_userId');
    try {
      final response = await http.get(
        Uri.parse('$_baseURL/usuarios/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      print('response.body ${response.statusCode}');

      if (response.statusCode == 200) {
        _currentUser = jsonDecode(response.body);
        print('Datos del usuario actual: $_currentUser');
      } else {
        throw Exception('Error al obtener los datos del usuario.');
      }
    } catch (error) {
      print('Error al buscar los datos del usuario: $error');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    _token = null;
    _isAuthenticated = false;
    _userId = null;
    _patientId = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('patientId'); // Limpiar cache del paciente

    notifyListeners();
  }

  // Autologin al abrir la app
  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return;

    _token = prefs.getString('token');
    if (_token != null) {
      if (JwtDecoder.isExpired(_token!)) {
        await logout(); // Si el token expiró, cerrar sesión
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(_token!);
      _userId = decodedToken['id'];

      _isAuthenticated = true;

      // Cargar datos del paciente y del usuario
      await _fetchPatientId();
      await _fetchCurrentUser();

      notifyListeners();
    }
  }
}