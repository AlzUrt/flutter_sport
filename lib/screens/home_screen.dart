import 'package:flutter/material.dart';
import 'package:sport/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        text: 'Cliquez ici',
        color: Colors.red,
        width: 250,
        height: 60,
        onPressed: () {
          // print('Bouton cliqué !');
        },
      ),
    );
  }
}
