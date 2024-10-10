import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport/widgets/custom_button.dart';
import 'dart:io';
import '../domain/exercice.dart';
import '../providers/exercices_provider.dart';

class ExercicesScreen extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  ExercicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
      floatingActionButton: CustomButton(
  icon: Icons.add,
  width: MediaQuery.of(context).size.width - 32, // 16 de chaque côté
  height: 60,
  onPressed: () {
    _showAddExerciceForm(context);
  },
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
    bool isTemps = true;
    Duration temps = const Duration(seconds: 30);
    int repetitions = 10;
    int series = 3;
    Duration pauseEntreSeries = const Duration(seconds: 30);

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
                    Container(
                      height: 200,
                      width: 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: 9,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                              child: Image.asset(
                                'assets/images/exercise${index + 1}.webp',
                                fit: BoxFit.cover,
                              ),
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
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Type: '),
                        ChoiceChip(
                          label: const Text('Temps'),
                          selected: isTemps,
                          onSelected: (bool selected) {
                            setState(() {
                              isTemps = selected;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        ChoiceChip(
                          label: const Text('Répétitions'),
                          selected: !isTemps,
                          onSelected: (bool selected) {
                            setState(() {
                              isTemps = !selected;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (isTemps)
                      Text('Temps: ${temps.inSeconds} secondes')
                    else
                      Text('Répétitions: $repetitions'),
                    Slider(
                      value: isTemps ? temps.inSeconds.toDouble() : repetitions.toDouble(),
                      min: 1,
                      max: isTemps ? 300 : 100,
                      divisions: isTemps ? 60 : 99,
                      label: isTemps ? temps.inSeconds.toString() : repetitions.toString(),
                      onChanged: (double value) {
                        setState(() {
                          if (isTemps) {
                            temps = Duration(seconds: value.round());
                          } else {
                            repetitions = value.round();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Nombre de séries: $series'),
                    Slider(
                      value: series.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: series.toString(),
                      onChanged: (double value) {
                        setState(() {
                          series = value.round();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('Pause entre séries: ${pauseEntreSeries.inSeconds} secondes'),
                    Slider(
                      value: pauseEntreSeries.inSeconds.toDouble(),
                      min: 0,
                      max: 300,
                      divisions: 60,
                      label: pauseEntreSeries.inSeconds.toString(),
                      onChanged: (double value) {
                        setState(() {
                          pauseEntreSeries = Duration(seconds: value.round());
                        });
                      },
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
                        customImagePath: customImagePath,
                        isTemps: isTemps,
                        temps: isTemps ? temps : null,
                        repetitions: isTemps ? null : repetitions,
                        series: series,
                        pauseEntreSeries: pauseEntreSeries,
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