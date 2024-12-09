import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/providers/user_auth_provider.dart';
import 'package:mediconecta_webapp/services/api_services.dart';
import 'package:mediconecta_webapp/ui/components/barChart.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDetailsPage extends StatefulWidget {
  final Appointment appointment;

  AppointmentDetailsPage(this.appointment);

  @override
  _AppointmentDetailsPageState createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  final _formKey = GlobalKey<FormState>(); // Para la validación del formulario

  // Controladores para los campos de texto
  final TextEditingController _motivoConsultaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _presionArterialController = TextEditingController();
  final TextEditingController _frecuenciaCardiacaController = TextEditingController();
  final TextEditingController _examenFisicoController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();
  final TextEditingController _tratamientoController = TextEditingController();
  final List<TextEditingController> _medicamentoControllers = [];
  final List<TextEditingController> _cadaHorasControllers = [];
  final List<TextEditingController> _diasControllers = [];
  final TextEditingController _recordatorioController = TextEditingController();
  final TextEditingController _repetirController = TextEditingController();
  final TextEditingController _cadaCuantosDiasController = TextEditingController();

  final ApiServices apiService = ApiServices();
  List<Map<String, dynamic>> registros = [];
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    // Inicializar controladores para medicamentos
    for (int i = 0; i < 2; i++) { // Ajusta el número de medicamentos según sea necesario
      _medicamentoControllers.add(TextEditingController());
      _cadaHorasControllers.add(TextEditingController());
      _diasControllers.add(TextEditingController());
    }

    _fetchRegistroSalud();
  }

  void _fetchRegistroSalud() async {
    try {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final patientId = userAuthProvider.patientId;

      final idMap = widget.appointment.id as Map<String, dynamic>;

      // Llamada para obtener citas pendientes
      final fetchedAppointments = await apiService.getRegistrosSalud(idMap['id_paciente']);

      setState(() {
        registros = fetchedAppointments; // Asigna la lista de citas
      });

      print('Registros de salud $registros');
    } catch (e) {
      print('Error al inicializar user en chartView$e');
    }
  }

  void _guardarFichaMedica() async {
    if (_formKey.currentState!.validate()) {
      // Aquí se puede agregar la lógica para guardar la ficha médica
      // final List<Map<String, dynamic>> medicamentos = [];
      // for (int i = 0; i < _medicamentoControllers.length; i++) {
      //   medicamentos.add({
      //     'nombre': _medicamentoControllers[i].text,
      //     'frecuencia': int.parse(_cadaHorasControllers[i].text),
      //     'dias': int.parse(_diasControllers[i].text),
      //   });
      // }

      final idMap = widget.appointment.id as Map<String, dynamic>;

      final fichaMedica = {
        'idCita': idMap['id_cita'] ?? 0,
        'idPaciente': idMap['id_paciente'] ?? 0,
        'idDoctor': idMap['id_doctor'] ?? 0,
        'motivoConsulta': _motivoConsultaController.text,
        'peso': double.tryParse(_pesoController.text) ?? 0.0,
        'altura': double.tryParse(_alturaController.text) ?? 0.0,
        'presionArterial': _presionArterialController.text,
        'frecuenciaCardiaca': int.tryParse(_frecuenciaCardiacaController.text) ?? 0,
        'examenFisico': _examenFisicoController.text,
        'diagnostico': _diagnosticoController.text,
        'tratamiento': _tratamientoController.text,
      };

      print('fichaMedica: $fichaMedica');

      try {
        ApiServices().crearFichaMedica(
          idCita: idMap['id_cita'] ?? 0,
          idPaciente: idMap['id_paciente'] ?? 0,
          idDoctor: idMap['id_doctor'] ?? 0,
          motivoConsulta: _motivoConsultaController.text,
          peso: int.tryParse(_pesoController.text) ?? 0,
          altura: int.tryParse(_alturaController.text) ?? 0,
          presionArterial: _presionArterialController.text,
          frecuenciaCardiaca: int.tryParse(_frecuenciaCardiacaController.text) ?? 0,
          examenFisico: _examenFisicoController.text,
          diagnostico: _diagnosticoController.text,
          tratamiento: _tratamientoController.text,
          //Quizas sea bueno crear otra tabla o lista para añadir los medicamentos o recordatorios relacionandolo con el id de la ficha medica y la cita
          // medicamentos: medicamentos,
          // recordatorio: _recordatorioController.text,
          // frecuenciaRecordatorio: int.parse(_repetirController.text),
          // diasRecordatorio: int.parse(_cadaCuantosDiasController.text),
        );

        ApiServices().updateCitaEstado(citaId: idMap['id_cita'] ?? 0, nuevoEstado: 'Completada');

        for (var controller in _medicamentoControllers) {
          print('controller.text ${controller.text}');
          await ApiServices().createRecordatorio(pacienteId: idMap['id_paciente'] ?? 0, doctorId: idMap['id_doctor'] ?? 0, fichaMedicaId: 1, descMedicamento: controller.text, frecuencia: 8, duracionDias: 5);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ficha médica guardada exitosamente!')),
        );
        
      } catch (e) {
        print('Error al guardar la ficha médica: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      // Llamada al servicio para guardar la ficha médica
      
    }
  }

  void clean(){
    setState(() {
      _motivoConsultaController.text = '';
      _pesoController.text = '';
      _alturaController.text = '';
      _presionArterialController.text = '';
      _frecuenciaCardiacaController.text = '';
      _examenFisicoController.text = '';
      _diagnosticoController.text = '';
      _tratamientoController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.appointment.subject),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _guardarFichaMedica,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.save, color: AppColors.iconColorPrimary,),
                          Text('Guardar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8,),
                GestureDetector(
                  onTap: clean,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.change_circle_sharp, color: AppColors.iconColorPrimary,),
                          Text('Limpiar', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Panel del paciente
            SingleChildScrollView(
              child: Container(
                width: size.width / 4,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Datos principales o cabecera
                      Row(
                        children: [
                          const SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001877.png',
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Text(
                                  widget.appointment.subject,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Rut: 7.982.781-1',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Edad: 66 años',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Sexo: Masculino',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Notes: ${widget.appointment.notes ?? "No notes available"}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
              
                      const SizedBox(height: 40),
              
                      // Indicadores
                      Container(
                        width: 260,
                        color: const Color.fromARGB(166, 13, 54, 87),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IndicatorItem(
                                    icon: Icons.dining,
                                    text: '85 kg',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  IndicatorItem(
                                    icon: Icons.keyboard_double_arrow_up_outlined,
                                    text: '176 cm',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  IndicatorItem(
                                    icon: Icons.water_drop_outlined,
                                    text: '36.1° C',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              // Right column
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IndicatorItem(
                                    icon: Icons.circle,
                                    text: '70 mmHg',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  IndicatorItem(
                                    icon: Icons.monitor_heart_outlined,
                                    text: '23 ppm',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                  IndicatorItem(
                                    icon: Icons.air,
                                    text: '25 frec. resp.',
                                    iconColor: Colors.white,
                                    textStyle: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 40,),
              
                      //Charts
                      Container(
                        width: size.width,
                        // color: const Color.fromARGB(255, 218, 219, 247),
                        child: Column(
                          children: [
                            TrendChartWidget(registros: registros),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 30,),

            // Ficha médica
            SingleChildScrollView(
              child: SizedBox(
                width: size.width / 1.5,
                child: Form( // Formulario para la validación
                  key: _formKey,
                  child: Column(
                    children: [
                      // Expandibles
                      const Column(
                        children: [
                          ExpansionTile(
                            collapsedBackgroundColor: Color.fromARGB(255, 199, 220, 237),
                            leading: Icon(
                              Icons.history,
                              color: AppColors.secondaryColor,
                            ),
                            title: Text(
                              '2 Atenciones pasadas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Aquí van los antecedentes médicos del paciente. Información detallada que se despliega al hacer clic.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),

                          ExpansionTile(
                            collapsedBackgroundColor: Color.fromARGB(255, 199, 220, 237),
                            leading: Icon(
                              Icons.upcoming,
                              color: AppColors.secondaryColor,
                            ),
                            title: Text(
                              '2 Atenciones próximas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Aquí van los antecedentes médicos del paciente. Información detallada que se despliega al hacer clic.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 30,),

                      // Formulario ficha médica
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Motivo de la consulta
                          const Text(
                            'Motivo de la consulta',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8,),
                          TextFormField(
                            controller: _motivoConsultaController,
                            decoration: const InputDecoration(
                              hintText: 'Ingrese el motivo de la consulta',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio'; // Mensaje de error
                              }
                              return null; // Campo válido
                            },
                          ),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              // Peso
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Peso (kg)',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _pesoController,
                                      decoration: const InputDecoration(
                                        hintText: 'Ingrese el peso',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo es obligatorio'; // Mensaje de error
                                        }
                                        return null; // Campo válido
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8,),
                              // Altura
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Altura (cm)',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _alturaController,
                                      decoration: const InputDecoration(
                                        hintText: 'Ingrese la altura',
                                        border: OutlineInputBorder(),
                                      ),
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo es obligatorio'; // Mensaje de error
                                        }
                                        return null; // Campo válido
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),

                          // Presión arterial
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Presión Arterial',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _presionArterialController,
                                      decoration: const InputDecoration(
                                        hintText: 'Ingrese la presión arterial',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo es obligatorio'; // Mensaje de error
                                        }
                                        return null; // Campo válido
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8,),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Frecuencia Cardíaca',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _frecuenciaCardiacaController,
                                      decoration: const InputDecoration(
                                        hintText: 'Ingrese la frecuencia cardíaca',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Este campo es obligatorio'; // Mensaje de error
                                        }
                                        return null; // Campo válido
                                      },
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          
                          const SizedBox(height: 20),                          
                          
                          // Examen físico
                          const Text(
                            'Examen Físico',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),                          
                          TextFormField(
                            controller: _examenFisicoController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Ingrese el examen físico',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio'; // Mensaje de error
                              }
                              return null; // Campo válido
                            },
                          ),
                          const SizedBox(height: 20),

                          // Diagnóstico
                          const Text(
                            'Diagnóstico',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _diagnosticoController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Ingrese el diagnóstico',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio'; // Mensaje de error
                              }
                              return null; // Campo válido
                            },
                          ),
                          const SizedBox(height: 20),

                          // Tratamiento
                          const Text(
                            'Tratamiento',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _tratamientoController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Ingrese el tratamiento',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Este campo es obligatorio'; // Mensaje de error
                              }
                              return null; // Campo válido
                            },
                          ),
                          const SizedBox(height: 20),

                          // Medicamentos
                          const Text(
                            'Medicamentos',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _medicamentoControllers.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: TextFormField(
                                          controller: _medicamentoControllers[index],
                                          decoration: const InputDecoration(
                                            hintText: 'Ingrese el nombre del medicamento',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Este campo es obligatorio'; // Mensaje de error
                                            }
                                            return null; // Campo válido
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: _cadaHorasControllers[index],
                                          decoration: const InputDecoration(
                                            hintText: 'Cada cuántas horas',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Este campo es obligatorio'; // Mensaje de error
                                            }
                                            return null; // Campo válido
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: TextFormField(
                                          controller: _diasControllers[index],
                                          decoration: const InputDecoration(
                                            hintText: 'Días de la semana',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Este campo es obligatorio'; // Mensaje de error
                                            }
                                            return null; // Campo válido
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(onPressed: (){}, icon: const Icon(Icons.delete_outline, color: Colors.red,))
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                          // Agregar botón para agregar más medicamentos si es necesario
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpiar controladores al final de la vida útil del widget
    _motivoConsultaController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();
    _presionArterialController.dispose();
    _frecuenciaCardiacaController.dispose();
    _examenFisicoController.dispose();
    _diagnosticoController.dispose();
    _tratamientoController.dispose();
    for (var controller in _medicamentoControllers) {
      controller.dispose();
    }
    for (var controller in _cadaHorasControllers) {
      controller.dispose();
    }
    for (var controller in _diasControllers) {
      controller.dispose();
    }
    _recordatorioController.dispose();
    _repetirController.dispose();
    _cadaCuantosDiasController.dispose();
    super.dispose();
  }
}

class IndicatorItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final TextStyle textStyle;

  const IndicatorItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textStyle,
        ),
      ],
    );
  }
}
