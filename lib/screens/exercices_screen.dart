import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../domain/exercice.dart';
import '../providers/exercices_provider.dart';

class ExercicesScreen extends StatelessWidget {

  final ImagePicker _picker = ImagePicker();

  ExercicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercices'),
      ),
      body: Consumer<ExercicesProvider>(
        builder: (context, exercicesProvider, child) {
          return ListView.builder(
            itemCount: exercicesProvider.exercices.length,
            itemBuilder: (context, index) {
              final exercice = exercicesProvider.exercices[index];
              return Dismissible(
                key: Key(exercice.name + index.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  exercicesProvider.deleteExercice(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${exercice.name} supprimé'))
                  );
                },
                child: ListTile(
                  title: Text(exercice.name),
                  leading: exercice.isCustomImage
                    ? Image.file(File(exercice.imagePath), width: 50, height: 50)
                    : Image.asset(exercice.imagePath, width: 50, height: 50),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmationDialog(context, exercicesProvider, index, exercice.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciceForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, ExercicesProvider provider, int index, String exerciceName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Êtes-vous sûr de vouloir supprimer $exerciceName ?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                provider.deleteExercice(index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$exerciceName supprimé'))
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddExerciceForm(BuildContext context) {
    String name = '';
    int? selectedImageIndex;
    String? customImagePath;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un exercice'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nom de l\'exercice'),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 20),
                    const Text('Sélectionnez une image :'),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImageIndex = index;
                                customImagePath = null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedImageIndex == index ? Colors.blue : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Image.asset('assets/images/exercise${index + 1}.webp'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          setState(() {
                            customImagePath = image.path;
                            selectedImageIndex = null;
                          });
                        }
                      },
                      child: const Text('Choisir une image personnalisée'),
                    ),
                    if (customImagePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.file(
                          File(customImagePath!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Ajouter'),
                  onPressed: () {
                    if (name.isNotEmpty && (selectedImageIndex != null || customImagePath != null)) {
                      final newExercice = Exercice(
                        name: name, 
                        imageIndex: selectedImageIndex, 
                        customImagePath: customImagePath
                      );
                      Provider.of<ExercicesProvider>(context, listen: false).addExercice(newExercice);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
}