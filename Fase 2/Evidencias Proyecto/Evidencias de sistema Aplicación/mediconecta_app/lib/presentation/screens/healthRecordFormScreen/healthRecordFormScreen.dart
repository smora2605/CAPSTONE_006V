import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

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

  String error = '';

  void _submitForm() {
      setState(() {
        error = '';
      });
    if(_glucoseController.text.isEmpty && _bloodPressureController.text.isEmpty && _heartRateController.text.isEmpty){
      setState(() {
        error = 'Debes ingresar como mínimo un registro de salud';
      });
    }
    // if (_formKey.currentState!.validate()) {
    //   final record = HealthRecord(
    //     date: DateTime.now(),
    //     glucoseLevel: double.parse(_glucoseController.text),
    //     bloodPressure: double.parse(_bloodPressureController.text),
    //     heartRate: double.parse(_heartRateController.text),
    //   );
    //   widget.onSave(record);
    //   Navigator.pop(context); // Cierra el formulario
    // }
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
                  
                  // const SizedBox(height: 20),
      
                  if(error.isNotEmpty)
                    Text(
                      error,
                      style: const TextStyle(
                        color: Colors.red
                      ),
                    ),
                  // const SizedBox(height: 20),
            
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
                      child: const Text(
                        'Registrar',
                        style: TextStyle(
                          color: AppColors.textColorPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}