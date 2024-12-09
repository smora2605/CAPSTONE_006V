import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TrendChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> registros; // Lista de registros de salud

  const TrendChartWidget({super.key, required this.registros});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Depuración: Imprimir cantidad y contenido de registros
    print('Cantidad de registros inicial: ${registros.length}');
    print('Registros iniciales: $registros');

    // Filtrar y mapear datos para presión arterial
    final List<FlSpot> pressureSpots = registros
        .asMap()
        .entries
        .where((entry) => entry.value['presion_arterial'] != null)
        .map((entry) {
          print(
              'Procesando registro: ${entry.key + 1}, valor: ${entry.value['presion_arterial']}');
          return FlSpot(
            (entry.key + 1).toDouble(),
            (entry.value['presion_arterial'] ?? 0).toDouble(),
          );
        })
        .toList();

    print('PressureSpots: $pressureSpots');

    // Filtrar y mapear datos para nivel de glucosa
    final List<FlSpot> glucoseSpots = registros
        .asMap()
        .entries
        .where((entry) => entry.value['nivel_glucosa'] != null)
        .map((entry) {
          print(
              'Procesando glucosa: ${entry.key + 1}, valor: ${entry.value['nivel_glucosa']}');
          return FlSpot(
            (entry.key + 1).toDouble(),
            (entry.value['nivel_glucosa'] ?? 0).toDouble(),
          );
        })
        .toList();

    print('GlucoseSpots: $glucoseSpots');

    // Filtrar y mapear datos para frecuencia cardíaca
    final List<FlSpot> frecuenciaSpots = registros
        .asMap()
        .entries
        .where((entry) => entry.value['frecuencia_cardiaca'] != null)
        .map((entry) {
          print(
              'Procesando frecuencia cardíaca: ${entry.key + 1}, valor: ${entry.value['frecuencia_cardiaca']}');
          return FlSpot(
            (entry.key + 1).toDouble(),
            (entry.value['frecuencia_cardiaca'] ?? 0).toDouble(),
          );
        })
        .toList();

    print('FrecuenciaSpots: $frecuenciaSpots');

    return Column(
      children: [
        const Text(
          'Presión Arterial (mmHg)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          width: size.width / 1.1,
          child: LineChart(
            _buildTrendChart(
              pressureSpots,
              maxY: 160,
              getDotColor: (value) {
                if (value < 90) return Colors.red; // Hipotensión
                if (value >= 90 && value <= 120) return Colors.green; // Normal
                return Colors.red; // Hipertensión
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Glucosa en Sangre (mg/dL)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          width: size.width / 1.1,
          child: LineChart(
            _buildTrendChart(
              glucoseSpots,
              maxY: 600,
              getDotColor: (value) {
                if (value < 70) return Colors.red; // Hipoglucemia
                if (value >= 70 && value <= 140) return Colors.green; // Normal
                return Colors.red; // Prediabetes o diabetes
              },
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Frecuencia Cardiaca (ppm)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          width: size.width / 1.1,
          child: LineChart(
            _buildTrendChart(
              frecuenciaSpots,
              maxY: 140,
              getDotColor: (value) {
                if (value < 60) return Colors.red; // Bradicardia
                if (value >= 60 && value <= 100) return Colors.green; // Normal
                return Colors.red; // Taquicardia
              },
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _buildTrendChart(
    List<FlSpot> spots, {
    required double maxY,
    required Color Function(double value) getDotColor,
  }) {
    return LineChartData(
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          spots: spots,
          color: Colors.white,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, _, __, ___) {
              return FlDotCirclePainter(
                radius: 8,
                color: getDotColor(spot.y), // Obtener el color dinámico
                strokeColor: Colors.white,
                strokeWidth: 2,
              );
            },
          ),
        ),
      ],
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                Text('Reg ${value.toInt()}'),
          ),
        ),
      ),
    );
  }
}
