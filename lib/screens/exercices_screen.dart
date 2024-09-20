import 'package:flutter/material.dart';
import '../domain/exercice.dart';

class ExercicesScreen extends StatefulWidget {
  const ExercicesScreen({super.key});


  @override
  _ExercicesScreenState createState() => _ExercicesScreenState();
}

class _ExercicesScreenState extends State<ExercicesScreen> {
  final List<Exercice> _exercices = [];

  void _addExercice(Exercice exercice) {
    setState(() {
      _exercices.add(exercice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercices'),
      ),
      body: ListView.builder(
        itemCount: _exercices.length,
        itemBuilder: (context, index) {
          final exercice = _exercices[index];
          return ListTile(
            title: Text(exercice.name),
            leading: Image.network(exercice.imageUrl, width: 50, height: 50),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciceForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExerciceForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String imageUrl = '';

        return AlertDialog(
          title: const Text('Ajouter un exercice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom de l\'exercice'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'URL de l\'image'),
                onChanged: (value) => imageUrl = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                if (name.isNotEmpty && imageUrl.isNotEmpty) {
                  _addExercice(Exercice(name: name, imageUrl: imageUrl));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}