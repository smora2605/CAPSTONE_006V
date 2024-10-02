import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

class AvailabilityListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> availability;
  final Function(int) onAvailabilitySelected;
  final int? selectedAvailabilityIndex;

  const AvailabilityListWidget({
    super.key,
    required this.availability,
    required this.onAvailabilitySelected,
    required this.selectedAvailabilityIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Selecciona una de las siguientes horas disponibles',
          style: TextStyle(
            color: AppColors.textColorDark,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        
        // Aseguramos que el contenido pueda desplazarse
        Expanded( // Expand para asegurar que SingleChildScrollView ocupe el espacio restante
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 10.0, // Espacio horizontal entre elementos
              runSpacing: 10.0, // Espacio vertical entre elementos
              children: availability.asMap().entries.map((entry) {
                final index = entry.key;
                final avail = entry.value;
                bool isSelected = index == selectedAvailabilityIndex;

                return GestureDetector(
                  onTap: () => onAvailabilitySelected(index), // Correcto paso del índice
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isSelected ? AppColors.primaryColor : Colors.white,
                    ),
                    child: Text(
                      avail['hora'],
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
