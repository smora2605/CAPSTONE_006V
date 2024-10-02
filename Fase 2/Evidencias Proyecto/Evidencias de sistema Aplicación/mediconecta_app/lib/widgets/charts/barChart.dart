import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Título del gráfico de barras
        const Text(
          'Presión Arterial (mmHg)',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            // Leyenda antes del gráfico
            Container(
              padding: const EdgeInsets.only(left: 70, right: 90),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leyenda del primer grupo de barras
                  Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      const Text('120'),
                    ],
                  ),
                  const SizedBox(width: 24), // Espacio entre cada leyenda
                  // Leyenda del segundo grupo de barras
                  Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      const Text('130'),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Leyenda del tercer grupo de barras
                  Row(
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      const Text('98'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16), // Espacio entre la leyenda y el gráfico

            // Aquí está el gráfico de barras
            SizedBox(
              height: 200,  // Ajustar tamaño
              width: size.width / 1.1,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 140,
                  barGroups: [
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: 120,
                        color: Colors.green,
                        width: 15,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(
                        toY: 130,
                        color: Colors.red,
                        width: 15,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(
                        toY: 98,
                        color: Colors.green,
                        width: 15,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ]),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          switch (value.toInt()) {
                            case 1:
                              return const Text('mes 1');
                            case 2:
                              return const Text('mes 2');
                            case 3:
                              return const Text('mes 3');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        interval: 20,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        interval: 20,
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}