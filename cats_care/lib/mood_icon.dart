import 'package:flutter/material.dart';

class MoodIcon extends StatelessWidget { // Changed to StatelessWidget
  final String icon;
  final String selectedTamTrang;
  final Function(String) onTap;

  const MoodIcon({Key? key, required this.icon, required this.selectedTamTrang, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(icon),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Text(
          icon,
          style: TextStyle(
            fontSize: 24,
            color: selectedTamTrang == icon ? Colors.blue : Colors.black87,
          ),
        ),
      ),
    );
  }
}