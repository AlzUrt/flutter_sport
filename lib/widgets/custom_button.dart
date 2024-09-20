import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double width; 
  final double height; 
  final VoidCallback onPressed;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.width = 200.0,
    this.height = 50.0,
  });

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
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
