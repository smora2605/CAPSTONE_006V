import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mediconecta_webapp/ui/theme/app_theme.dart';

class CardChartAdminWidget extends StatelessWidget {
  final String title;
  final String desc;
  final double count;
  final Icon icon;
  final String chart;

  const CardChartAdminWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.count,
    required this.icon,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), // Esquinas redondeadas
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 8.0,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 8), // Espacio entre ícono y texto
                  Text(title),
                ],
              ),
              const Icon(Icons.arrow_forward_outlined),
            ],
          ),
          const SizedBox(height: 8), // Espacio entre el Row y el Divider
          const Divider(
            color: AppColors.borderColorGrey,
            thickness: 1, // Grosor de la línea
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 30,      // Tamaño grande
                        fontWeight: FontWeight.bold,  // Ennegrecido
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4), // Espacio entre los textos
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 14,    // Más pequeño
                        color: Colors.grey, // Color gris
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Espacio entre los textos y el gráfico
              Expanded(child: chart == 'bar' ? _buildBarChart() : _buildCircularChart()), // Gráfico de barras pequeño
            ],
          ),
        ],
      ),
    );
  }

  // Gráfico de barras pequeño usando fl_chart
  Widget _buildBarChart() {
    return SizedBox(
      width: 100,
      height: 60,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 30,
                  color: Colors.blue.shade100,
                  width: 12,
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 60,
                  color: Colors.blue.shade100,
                  width: 12,
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: count,
                  color: Colors.blue,
                  width: 12,
                ),
              ],
            ),
          ],
          borderData: FlBorderData(show: false), // Sin bordes alrededor del gráfico
          titlesData: const FlTitlesData(show: false), // Sin títulos en los ejes
        ),
      ),
    );
  }

  Widget _buildCircularChart() {
    return SizedBox(
      width: 100,
      height: 100,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 40,
              color: Colors.blue.shade100,
              radius: 30,
              title: '30%',
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            PieChartSectionData(
              value: count,
              color: Colors.blue,
              radius: 30,
              title: '70%',
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          borderData: FlBorderData(show: false), // Sin bordes alrededor
          sectionsSpace: 2, // Espacio entre las secciones del gráfico
          centerSpaceRadius: 20, // Espacio en el centro (opcional para estilo de spinner)
        ),
      ),
    );
  }
}
