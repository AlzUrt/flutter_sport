import 'package:flutter/material.dart';
import 'package:sport/widgets/custom_button.dart';
import 'package:sport/widgets/session_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SessionCard(name: 'name', date: DateTime.utc(1989, 11, 9)),
          CustomButton(
            text: 'Ajouter une séance',
            width: 250,
            height: 60,
            onPressed: () {
              print('Bouton cliqué !');
            },
          ),
          
        ],
      )
    );
  }
}
