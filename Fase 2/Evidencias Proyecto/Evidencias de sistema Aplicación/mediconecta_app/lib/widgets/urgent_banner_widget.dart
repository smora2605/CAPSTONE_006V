import 'package:flutter/material.dart';

class ImportantBanner extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;

  const ImportantBanner({
    super.key,
    required this.message,
    required this.icon,
    this.backgroundColor = Colors.yellow,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: textColor,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
