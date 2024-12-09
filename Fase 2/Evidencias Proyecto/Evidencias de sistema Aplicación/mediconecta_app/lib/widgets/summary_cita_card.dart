import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCitaCard extends StatelessWidget {
  final Map<String, dynamic> summaryCita;

  const SummaryCitaCard({
    super.key,
    required this.summaryCita,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor's name and specialty
            Text(
              summaryCita['DoctorName'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              summaryCita['Especialidad'],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            const Divider(height: 20, color: Colors.grey),

            // Date and time of the appointment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Fecha:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  summaryCita['Fecha'] != null
                    ? DateFormat('dd/MM/yyyy').format(DateTime.parse(summaryCita['Fecha']))
                    : 'Fecha no disponible',
                  style: const TextStyle(fontSize: 18)
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Hora:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(summaryCita['HoraSeleccionada'], style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),

            // Motivo de la cita
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Motivo:",
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            //     ),
            //     Flexible(child: Text('motivo')),
            //   ],
            // ),
            // const SizedBox(height: 8),

            // Estado de la cita
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Estado:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  summaryCita['Estado'],
                  style: TextStyle(
                    color: summaryCita['Estado'] == 'Pendiente' ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Colors.grey),

          ],
        ),
      ),
    );
  }
}
