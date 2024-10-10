import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final double width;
  final double height;
  final VoidCallback onPressed;

  CustomButton({
    this.text,
    this.icon,
    required this.onPressed,
    this.width = 200.0,
    this.height = 50.0,
  }) : assert(text != null || icon != null, 'Au moins un texte ou une icône doit être fourni.');

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = Theme.of(context).primaryColor;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              if (text != null) const SizedBox(width: 8),
            ],
            if (text != null)
              Text(
                text!,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}