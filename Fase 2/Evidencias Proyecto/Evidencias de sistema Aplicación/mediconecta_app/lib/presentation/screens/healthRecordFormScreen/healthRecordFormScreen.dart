import 'package:flutter/material.dart';
import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/theme/theme.dart';
import 'package:provider/provider.dart';

class HealthRecordFormScreen extends StatefulWidget {
  const HealthRecordFormScreen({super.key});

  @override
  State<HealthRecordFormScreen> createState() => _HealthRecordFormScreenState();
}

class _HealthRecordFormScreenState extends State<HealthRecordFormScreen> {

  final _formKey = GlobalKey<FormState>();
  final _glucoseController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _heartRateController = TextEditingController();

  final ApiService apiService = ApiService();

  String error = '';
  bool _isLoading = false; // Estado para el spinner

  // Función para mostrar el diálogo de éxito o error
  void _showDialog(String title, String message, {bool isSuccess = true}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: isSuccess ? Colors.green : Colors.red),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                if (isSuccess) {
                  Navigator.of(context).pop(); // Cerrar el formulario si es exitoso
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    // Reiniciar el estado de error
    setState(() {
      error = '';
      _isLoading = true; // Comenzar el proceso de carga
    });

    // Verificar que al menos un campo esté completo
    if (_glucoseController.text.isEmpty && 
        _bloodPressureController.text.isEmpty && 
        _heartRateController.text.isEmpty) {
      _showDialog('Error', 'Debes ingresar como mínimo un registro de salud', isSuccess: false);
      setState(() {
        _isLoading = false; // Detener el proceso de carga
      });
      return;
    }

    try {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final patientId = userAuthProvider.patientId;

      print('patientIdRegistroSalud$patientId');

      // Obtener valores de los controladores, o dejar en null si están vacíos
      final int? nivelGlucosa = _glucoseController.text.isNotEmpty 
          ? int.tryParse(_glucoseController.text) 
          : null;
      final int? presionArterial = _bloodPressureController.text.isNotEmpty 
          ? int.tryParse(_bloodPressureController.text) 
          : null;
      final int? frecuenciaCardiaca = _heartRateController.text.isNotEmpty 
          ? int.tryParse(_heartRateController.text) 
          : null;

      // Llamar a la función de creación del registro de salud
      final response = await apiService.createRegistroSalud(
        pacienteId: patientId!, // Asegúrate de que pacienteId esté definido
        nivelGlucosa: nivelGlucosa,
        presionArterial: presionArterial,
        frecuenciaCardiaca: frecuenciaCardiaca,
      );

      setState(() {
        _isLoading = false; // Detener el proceso de carga
      });

      if (response != null) {
        _showDialog('Éxito', 'Registro de salud creado exitosamente', isSuccess: true);
      } else {
        _showDialog('Error', 'Error al crear el registro de salud. Inténtalo de nuevo.', isSuccess: false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Detener el proceso de carga
      });
      _showDialog('Error', 'Ocurrió un error: $e', isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text('Añadir registro de salud')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nivel de glucosa',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1
                            ),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _glucoseController,
                            decoration: const InputDecoration(
                              labelText: 'Registra aquí',
                              labelStyle: TextStyle(
                                fontSize: 22,
                                letterSpacing: 2
                              ),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            ),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Presión Arterial',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1
                            ),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _bloodPressureController,
                            decoration: const InputDecoration(
                              labelText: 'Registra aquí',
                              labelStyle: TextStyle(
                                fontSize: 22, 
                                letterSpacing: 2
                              ),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            ),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Frecuencia Cardíaca',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1
                            ),
                          ),
                          const SizedBox(height: 10,),
                          TextFormField(
                            controller: _heartRateController,
                            decoration: const InputDecoration(
                              labelText: 'Registra aquí',
                              labelStyle: TextStyle(
                                fontSize: 22,
                                letterSpacing: 2
                              ),
                              helperMaxLines: 2,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            ),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w500
                            ),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _submitForm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: _isLoading // Mostrar spinner si está cargando
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColorPrimary),
                            )
                          : const Text(
                              'Registrar',
                              style: TextStyle(
                                color: AppColors.textColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),
                              textAlign: TextAlign.center,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
