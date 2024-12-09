import 'package:flutter/material.dart';

class StatusModal extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onClose;

  const StatusModal({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Row(
        children: [
          Icon(
            icon,
            size: 28,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: iconColor,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      actions: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onClose,
          icon: const Icon(Icons.close),
          label: const Text('Cerrar'),
        ),
      ],
    );
  }
}