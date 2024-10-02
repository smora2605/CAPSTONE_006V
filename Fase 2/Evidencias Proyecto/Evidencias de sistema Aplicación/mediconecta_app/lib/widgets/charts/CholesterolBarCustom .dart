import 'package:flutter/material.dart';

class CholesterolBarCustom extends StatelessWidget {
  final double cholesterolLevel;

  const CholesterolBarCustom({super.key, required this.cholesterolLevel});

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
    if (cholesterolLevel <= 200) {
      faceEmoji = '😃'; // Feliz para el rango verde
    } else if (cholesterolLevel > 200 && cholesterolLevel <= 240) {
      faceEmoji = '😕'; // Neutro para el rango amarillo
    } else {
      faceEmoji = '☹️'; // Triste para el rango rojo
    }

    // Calcular la posición de la carita en función del nivel de colesterol
    double leftPosition = 0;
    if (cholesterolLevel <= 200) {
      leftPosition = (cholesterolLevel / 280) * segmentWidth;
    } else if (cholesterolLevel > 200 && cholesterolLevel <= 240) {
      leftPosition = segmentWidth + ((cholesterolLevel - 201) / 53) * segmentWidth + separationWidth;
    } else {
      leftPosition = (2 * segmentWidth) + ((cholesterolLevel - 240) / 60) * segmentWidth + (2 * separationWidth);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Colesterol total: ${cholesterolLevel.toStringAsFixed(0)} mg/dL",
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
                    width: segmentWidth, // Verde hasta 200 mg/dL
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Amarillo entre 201-240 mg/dL
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Rojo más de 240 mg/dL
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
          // Rango de colesterol (0 a 300 mg/dL)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0 mg/dL"),
              Text("200 mg/dL"),
              Text("240 mg/dL"),
              Text("300 mg/dL"),
            ],
          ),
        ],
      ),
    );
  }
}