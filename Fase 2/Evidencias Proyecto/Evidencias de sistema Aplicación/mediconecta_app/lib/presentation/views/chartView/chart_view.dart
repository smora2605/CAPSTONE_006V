import 'package:flutter/material.dart';
import 'package:mediconecta_app/api/apiService.dart';
import 'package:mediconecta_app/provider/user_auth_provider.dart';
import 'package:mediconecta_app/widgets/charts/BloodPressureBarCustom.dart';
import 'package:mediconecta_app/widgets/charts/CholesterolBarCustom%20.dart';
import 'package:mediconecta_app/widgets/charts/GlucoseBarCustom.dart';
import 'package:mediconecta_app/widgets/charts/barChart.dart';
import 'package:provider/provider.dart';

class ChartView extends StatefulWidget {
  const ChartView({super.key});

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> registros = [];
  bool isLoading = true; // Indicador de carga


  @override
  void initState() {
    super.initState();
    _fetchRegistroSalud();
  }

  void _fetchRegistroSalud() async {
    try {
      final userAuthProvider = Provider.of<UserAuthProvider>(context, listen: false);
      final patientId = userAuthProvider.patientId;

      // Llamada para obtener citas pendientes
      final fetchedAppointments = await apiService.getRegistrosSalud(patientId!);

      setState(() {
        registros = fetchedAppointments; // Asigna la lista de citas
      });

      print('Registros de salud $registros');
    } catch (e) {
      print('Error al inicializar user en chartView$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _fetchRegistroSalud(); // Llama a la función al deslizar hacia abajo
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Estado de salud actual',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
        
              const CholesterolBarCustom(cholesterolLevel: 100.0),
              const BloodpressureBarCustom(bloodPressureLevel: 139.0),
              const GlucoseBarCustom(glucoseLevel: 126.0),
        
              const SizedBox(height: 40),
        
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Estado de salud historico',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
        
              const SizedBox(height: 20),
        
              TrendChartWidget(registros: registros),
        
              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
