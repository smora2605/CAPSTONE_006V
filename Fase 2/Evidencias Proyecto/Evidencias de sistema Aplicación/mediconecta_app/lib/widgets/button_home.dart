import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

class ButtonHomeWidget extends StatelessWidget {
  const ButtonHomeWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.action
  });

  final String title;
  final IconData icon;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: action,
      child: Container(
        width: size.width / 1.2, //80% del ancho
        height: 90,
        decoration: const BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 34,
                  color: AppColors.iconColorPrimary,
                ),
                const SizedBox(width: 14,),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textColorPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
            const Icon(
              Icons.chevron_right,
              size: 30,
              color: AppColors.iconColorPrimary,
            )
          ],
        ),
      ),
    );
  }
}