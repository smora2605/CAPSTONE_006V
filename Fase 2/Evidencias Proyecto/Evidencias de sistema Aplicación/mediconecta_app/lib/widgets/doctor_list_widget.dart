import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

class DoctorListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> doctors;
  final Function(int) onDoctorSelected;
  final int? selectedDoctorIndex;

  const DoctorListWidget({
    required this.doctors,
    required this.onDoctorSelected,
    required this.selectedDoctorIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Selecciona uno de las siguientes doctores',
          style: TextStyle(
            color: AppColors.textColorDark,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              bool isSelected = index == selectedDoctorIndex;
              return GestureDetector(
                onTap: () {
                  onDoctorSelected(index); // Llamar a la función de callback cuando se selecciona un doctor
                  
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // Cambia la posición de la sombra
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del doctor
                        Image.network(
                          'https://static.vecteezy.com/system/resources/previews/002/181/615/original/medical-doctor-general-practitioner-physician-profile-avatar-cartoon-vector.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16.0), // Espacio entre la imagen y el texto
                        // Detalles del doctor
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${doctor['nombre']}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${doctor['especialidad']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                            // const SizedBox(height: 4.0),
                            // Text(
                            //   'Disponible: ${doctor['time']}',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // return ListTile(
              //   title: Text('${doctor['name']} (${doctor['specialty']})'),
              //   subtitle: Text('Disponible: ${doctor['time']}'),
              // );
            },
          ),
        ),
      ],
    );
  }
}
