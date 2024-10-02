import 'package:flutter/material.dart';

class GlucoseBarCustom extends StatelessWidget {
  final double glucoseLevel;

  const GlucoseBarCustom({super.key, required this.glucoseLevel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Configuraciones para la barra
    const double heightBarr = 40;
    const double segmentWidthFactor = 4.5; // Factor para dividir la pantalla
    const double separationWidth = 2; // Ancho de separación entre segmentos

    double totalWidth = size.width / segmentWidthFactor; // Ancho total de cada segmento
    double segmentWidth = totalWidth; // Ancho de cada segmento
    double totalBarWidth = (segmentWidth * 4) + (separationWidth * 3); // Ancho total de la barra (4 segmentos)

    // Determinar la carita en base al nivel de glucosa
    String faceEmoji = '😃';
    if (glucoseLevel >= 0 && glucoseLevel <= 69) {
      faceEmoji = '☹️'; // Triste para el rango azul (hipoglucemia)
    } else if (glucoseLevel >= 70 && glucoseLevel <= 99) {
      faceEmoji = '😃'; // Feliz para el rango verde
    } else if (glucoseLevel >= 100 && glucoseLevel <= 125) {
      faceEmoji = '😕'; // Neutro para el rango amarillo
    } else {
      faceEmoji = '☹️'; // Triste para el rango rojo
    }

    // Calcular la posición de la carita en función del nivel de glucosa
    double leftPosition = 0;
    if (glucoseLevel >= 0 && glucoseLevel <= 69) {
      leftPosition = (glucoseLevel / 110) * segmentWidth; // Posicionar en el segmento azul
    } else if (glucoseLevel >= 70 && glucoseLevel <= 99) {
      leftPosition = segmentWidth + ((glucoseLevel - 70) / 46) * segmentWidth + separationWidth; // Posicionar en el segmento verde
    } else if (glucoseLevel >= 100 && glucoseLevel <= 125) {
      leftPosition = (2 * segmentWidth) + ((glucoseLevel - 100) / 40) * segmentWidth + (2 * separationWidth); // Posicionar en el segmento amarillo
    } else {
      leftPosition = (3 * segmentWidth) + ((glucoseLevel - 126) / 74) * segmentWidth + (3 * separationWidth); // Posicionar en el segmento rojo
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Glucosa en la sangre: ${glucoseLevel.toStringAsFixed(0)} mg/dL",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // Barra de progreso personalizada
          Stack(
            children: [
              // Barra segmentada de fondo (azul, verde, amarillo, rojo)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: segmentWidth, // Azul para 0-69 mg/dL (hipoglucemia)
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Verde para 70-99 mg/dL (normal)
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Amarillo para 100-125 mg/dL (pre-diabetes)
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(width: separationWidth),
                  Container(
                    width: segmentWidth, // Rojo para más de 125 mg/dL (diabetes)
                    height: heightBarr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              // Indicador de nivel de glucosa con carita
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
          // Rango de glucosa (0 a 200 mg/dL)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("0 mg/dL"),
              Text("70 mg/dL"),
              Text("100 mg/dL"),
              Text("126 mg/dL"),
              Text("200 mg/dL"),
            ],
          ),
        ],
      ),
    );
  }
}
