import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

class SpeedometerWidget extends StatelessWidget {
  const SpeedometerWidget({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(10),
      width: size.width / 1.2,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColorGrey,
            width: 2,
          ),
        ),
        // color: AppColors.backgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                // width: 200,
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        title,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 20,fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    // const SizedBox(width: 10,),
                    // GestureDetector(
                    //   onTap: (){},
                    //   child: const Icon(
                    //     Icons.info_outline,
                    //     size: 24,
                    //     color: AppColors.primaryColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: value <= 33
                            ? Colors.green
                            : value <= 66
                                ? Colors.yellow
                                : Colors.red,
                          width: 2
                        ),
                        // color: AppColors.backgroundColor,
                      ),
                      child: Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: value <= 33
                          ? Colors.green
                          : value <= 66
                              ? Colors.yellow
                              : Colors.red,
                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                      child: Text(
                        value <= 33
                          ? 'Bajo'
                          : value <= 66
                            ? 'Medio'
                            : 'Alto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){},
                      child: const Icon(
                        Icons.info_outline,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: 200,
            height: 90,
            child: CustomPaint(
              painter: SpeedometerPainter(value: value),
            ),
          ),
          const SizedBox(height: 10,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0'),
              Text('100'),
            ],
          ),
        ],
      ),
    );
  }
}


//CANVAS DEL GRÁFICO
class SpeedometerPainter extends CustomPainter {
  final int value;

  SpeedometerPainter({required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    const startAngle = pi;
    const sweepAngle = pi;
    
    final greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    final yellowPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    final redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    // Dibujar los segmentos de colores
    canvas.drawArc(rect, startAngle, sweepAngle * 0.33, false, greenPaint);
    canvas.drawArc(rect, startAngle + sweepAngle * 0.33, sweepAngle * 0.33, false, yellowPaint);
    canvas.drawArc(rect, startAngle + sweepAngle * 0.66, sweepAngle * 0.34, false, redPaint);

    // Dibujar el puntero
    final pointerAngle = startAngle + (value / 100) * sweepAngle;
    final center = Offset(size.width / 2, size.height);
    final pointerLength = size.height;
    final pointerEnd = Offset(
      center.dx + pointerLength * cos(pointerAngle),
      center.dy + pointerLength * sin(pointerAngle),
    );

    final pointerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;

    canvas.drawLine(center, pointerEnd, pointerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}