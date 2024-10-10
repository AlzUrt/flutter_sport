import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport/domain/exercice.dart';
import '../providers/seances_provider.dart';
import '../providers/exercices_provider.dart';
import '../domain/seance.dart';
class SeancesScreen extends StatelessWidget {
  const SeancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Séances'),
      ),
      body: Consumer<SeancesProvider>(
        builder: (context, seancesProvider, child) {
          return ListView.builder(
            itemCount: seancesProvider.seances.length,
            itemBuilder: (context, index) {
              final seance = seancesProvider.seances[index];
              return ListTile(
                title: Text(seance.nom),
                subtitle: Text('${seance.exercices.length} exercices - ${seance.type.toString().split('.').last}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => seancesProvider.deleteSeance(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSeanceForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSeanceForm(BuildContext context) {
    final exercicesProvider = Provider.of<ExercicesProvider>(context, listen: false);
    
    String nom = '';
    List<Exercice> exercicesSeance = [];
    Duration pauseEntreExercices = Duration.zero;
    SeanceType type = SeanceType.AMRAP;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Créer une séance'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Nom de la séance'),
                      onChanged: (value) => nom = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showAddExercicesToSeanceForm(context, exercicesProvider, (newExercices) {
                        setState(() {
                          exercicesSeance = newExercices;
                        });
                      }),
                      child: const Text('Gérer les exercices'),
                    ),
                    const SizedBox(height: 10),
                    Text('Exercices ajoutés: ${exercicesSeance.length}'),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<SeanceType>(
                      value: type,
                      onChanged: (SeanceType? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                      items: SeanceType.values.map((SeanceType seanceType) {
                        return DropdownMenuItem<SeanceType>(
                          value: seanceType,
                          child: Text(seanceType.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text('Pause entre exercices: ${pauseEntreExercices.inSeconds} secondes'),
                    Slider(
                      value: pauseEntreExercices.inSeconds.toDouble(),
                      min: 0,
                      max: 300,
                      divisions: 60,
                      label: pauseEntreExercices.inSeconds.toString(),
                      onChanged: (double value) {
                        setState(() {
                          pauseEntreExercices = Duration(seconds: value.round());
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
                  child: const Text('Créer'),
                  onPressed: () {
                    if (nom.isNotEmpty && exercicesSeance.isNotEmpty) {
                      final newSeance = Seance(
                        nom: nom,
                        exercices: exercicesSeance,
                        type: type,
                      );
                      Provider.of<SeancesProvider>(context, listen: false).addSeance(newSeance);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

     void _showAddExercicesToSeanceForm(BuildContext context, ExercicesProvider exercicesProvider, Function(List<Exercice>) onUpdate) {
    List<Exercice> selectedExercices = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Gérer les exercices de la séance'),
              content: Container(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: exercicesProvider.exercices.map((exercice) => CheckboxListTile(
                          title: Text(exercice.name),
                          value: selectedExercices.contains(exercice),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                if (!selectedExercices.contains(exercice)) {
                                  selectedExercices.add(exercice);
                                }
                              } else {
                                selectedExercices.remove(exercice);
                              }
                            });
                          },
                        )).toList(),
                      ),
                    ),
                    const Divider(),
                    const Text('Exercices sélectionnés (glisser "=" pour réordonner):'),
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: selectedExercices.length,
                        itemBuilder: (context, index) {
                          final exercice = selectedExercices[index];
                          return Card(
                            key: ValueKey(exercice),
                            child: ListTile(
                              title: Text(exercice.name),
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onPanUpdate: (details) {
                                    // Cette fonction sera appelée lors du glissement
                                  },
                                  child: Container(
                                    width: 60, // Largeur de la zone de drag
                                    height: 60, // Hauteur de la zone de drag
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.drag_handle),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Exercice item = selectedExercices.removeAt(oldIndex);
                            selectedExercices.insert(newIndex, item);
                          });
                        },
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
                  child: const Text('Valider'),
                  onPressed: () {
                    onUpdate(selectedExercices);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}