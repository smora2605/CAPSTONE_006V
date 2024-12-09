import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';
import 'package:mediconecta_app/widgets/peso_widget.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        const Text(
                          'Tú perfil',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(
                              child: Column(
                                children: [
                                  Text(
                                    'Edad',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorGrey),
                                  ),
                                  Text(
                                    '63 años',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14.0, horizontal: 26.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.borderColorGrey,
                                  ),
                                  right: BorderSide(
                                    color: AppColors.borderColorGrey,
                                  ),
                                ),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    'Sexo',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorGrey),
                                  ),
                                  Text(
                                    'M',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              child: Column(
                                children: [
                                  Text(
                                    'Estatura',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.textColorGrey),
                                  ),
                                  Text(
                                    '178cm',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const PesoWidget(peso: 69),
        
              // Agregamos el nuevo widget de recomendaciones
              const SizedBox(height: 20),
              const RecommendationsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class RecommendationsWidget extends StatelessWidget {
  const RecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Recomendaciones',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Tarjeta de Alimentación
        RecommendationCard(
          imageUrl: 'https://www.fao.org/images/rlclibraries/news/organic-food-for-healthy-nutrition-and-superfoods-epfyh7j.jpg?sfvrsn=d7270160_2',
          title: 'Alimentación Saludable',
          description: 'Descubre cómo una alimentación balanceada puede mejorar tu salud.',
          onTap: () {
            // Aquí puedes agregar la lógica para navegar a una nueva página
          },
        ),
        const SizedBox(height: 16),
        // Tarjeta de Actividad Física
        RecommendationCard(
          imageUrl: 'https://www.gradior.es/wp-content/uploads/2024/02/Diseno-sin-titulo-3.png',
          title: 'Actividad Física Regular',
          description: 'La importancia del ejercicio diario para una vida activa.',
          onTap: () {
            // Aquí puedes agregar la lógica para navegar a una nueva página
          },
        ),
        const SizedBox(height: 16),
        // Tarjeta de Buen Sueño
        RecommendationCard(
          imageUrl: 'https://regenerahealth.com/wp-content/uploads/2023/09/suenos-lucidos-que-son-1024x683.jpg',
          title: 'Importancia del Sueño',
          description: 'Consejos para mejorar la calidad de tu sueño cada noche.',
          onTap: () {
            // Aquí puedes agregar la lógica para navegar a una nueva página
          },
        ),
      ],
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final VoidCallback onTap;

  const RecommendationCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
