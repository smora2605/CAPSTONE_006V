import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfirmCitaCard extends StatelessWidget {
  final Map<String, dynamic> citaElement;

  const ConfirmCitaCard({
    super.key,
    required this.citaElement,
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
              '${citaElement['doctor_genero'] == 'M' ? 'Dr.' : 'Dra.'}  ${citaElement['doctor_nombre']}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              citaElement['especialidad'],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),

            const Divider(height: 20, color: Colors.grey),

            const Text(
              "Datos de la cita",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(height: 10,),
            // Date and time of the appointment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "fecha:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  citaElement['fecha'] != null
                    ? DateFormat('dd/MM/yyyy').format(DateTime.parse(citaElement['fecha']))
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
                Text(citaElement['hora'], style: const TextStyle(fontSize: 18)),
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
                  citaElement['estado'],
                  style: TextStyle(
                    color: citaElement['estado'] == 'Pendiente' ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Colors.grey),

            const Text(
              "Datos del paciente",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            const SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nombre:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  citaElement['paciente_nombre'],
                  style: const TextStyle(fontSize: 18)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
