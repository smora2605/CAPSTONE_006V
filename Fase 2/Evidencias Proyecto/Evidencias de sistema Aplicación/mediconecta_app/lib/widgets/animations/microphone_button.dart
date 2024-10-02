import 'package:flutter/material.dart';
import 'package:mediconecta_app/theme/theme.dart';

class MicrophoneButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback startListening;
  final VoidCallback stopListening;

  const MicrophoneButton({
    super.key,
    required this.isListening,
    required this.startListening,
    required this.stopListening,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Botón presionado. Estado de escuchar: $isListening');
        isListening ? stopListening() : startListening();
      },
      child: AnimatedScale(
        scale: isListening ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Icon(
            isListening ? Icons.mic_off : Icons.mic,
            size: 60,
            color: AppColors.iconColorPrimary,
          ),
        ),
      ),
    );
  }
}
