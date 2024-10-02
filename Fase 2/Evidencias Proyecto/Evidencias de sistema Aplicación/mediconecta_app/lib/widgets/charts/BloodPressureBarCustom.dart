import 'package:flutter/material.dart';

class BloodpressureBarCustom extends StatelessWidget {
  final double bloodPressureLevel;

  const BloodpressureBarCustom({super.key, required this.bloodPressureLevel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Configuraciones para la barra
    const double heightBarr = 40;
    const double segmentWidthFactor = 3.3; // Factor para dividir la pantalla
    const double separationWidth = 2; // Ancho de separación entre segmentos

    double totalWidth = size.width / segmentWidthFactor; // Ancho total de cada segmento
    double segmentWidth = totalWidth; // Ancho de cada segmento
    double totalBarWidth = (segmentWidth * 3) + (separationWidth * 2); // Ancho total de la barra

    // Determinar la carita en base al nivel de colesterol
    String faceEmoji = '😃';
    if (bloodPressureLevel < 120) {
      faceEmoji = '😃'; // Feliz para el rango verde
    } else if (bloodPressureLevel >= 120 && bloodPressureLevel <= 139) {
      faceEmoji = '😕'; // Neutro para el rango amarillo
    } else {
      faceEmoji = '☹️'; // Triste para el rango rojo
    }

    // Calcular la posición de la carita en función del nivel de colesterol
    double leftPosition = 0;
    if (bloodPressureLevel < 120) {
      leftPosition = (bloodPressureLevel / 120) * segmentWidth;
    } else if (bloodPressureLevel >= 120 && bloodPressureLevel <= 139) {
      leftPosition = segmentWidth + ((bloodPressureLevel - 120) / 28) * segmentWidth + separationWidth;
    } else {
      leftPosition = (2 * segmentWidth) + ((bloodPressureLevel - 140) / 40) * segmentWidth + (2 * separationWidth);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Presión arterial: ${bloodPressureLevel.toStringAsFixed(0)} mmHg",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // Barra de progreso personalizada
          Stack(
            children: [
              // Barra segmentada de fondo (verde, amarillo, rojo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: segmentWidth, // Verde hasta 200 mmHg
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Amarillo entre 201-240 mmHg
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Rojo más de 240 mmHg
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              // Indicador de nivel de colesterol con carita
              Positioned(
                left: leftPosition.clamp(0, totalBarWidth - 50), // Ajuste la posición según el nivel
                top: -3, // Un poco por encima de la barra
                child: Text(
                  faceEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Rango de colesterol (0 a 300 mmHg)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0 mmHg"),
              Text("120 mmHg"),
              Text("140 mmHg"),
              Text("200 mmHg"),
            ],
          ),
        ],
      ),
    );
  }
}