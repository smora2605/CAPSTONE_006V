import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart'; // Asegúrate de ajustar esto a tu archivo de tema

class PesoWidget extends StatelessWidget {
  final double peso; // Peso de la persona
  final String unidad; // Unidad de medida (kg, lb, etc.)

  const PesoWidget({
    super.key,
    required this.peso,
    this.unidad = "kg", // Unidad por defecto es kg
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 26.0),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(
            color: AppColors.borderColorGrey,
          ),
          top: BorderSide(
            color: AppColors.borderColorGrey,
          )
        ),
        // color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.monitor_weight, // Icono de peso
                color: AppColors.primaryColor,
                size: 55,
              ),
              const SizedBox(width: 10),
              Text(
                '$peso $unidad', // Muestra el peso con la unidad
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColorDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Peso Actual',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textColorGrey,
            ),
          ),
        ],
      ),
    );
  }
}
