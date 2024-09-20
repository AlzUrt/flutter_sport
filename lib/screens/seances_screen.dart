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
    List<ExerciceSeance> exercicesSeance = [];
    Duration pauseEntreSeries = Duration.zero;
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
                      onPressed: () => _showAddExerciceToSeanceForm(context, exercicesProvider, (newExerciceSeance) {
                        setState(() {
                          exercicesSeance.add(newExerciceSeance);
                        });
                      }),
                      child: const Text('Ajouter un exercice'),
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
                        pauseEntreSeries: pauseEntreSeries,
                        pauseEntreExercices: pauseEntreExercices,
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

  void _showAddExerciceToSeanceForm(BuildContext context, ExercicesProvider exercicesProvider, Function(ExerciceSeance) onAdd) {
    Exercice? selectedExercice;
    bool isTemps = true;
    int repetitions = 1;
    Duration temps = const Duration(seconds: 30);
    int series = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un exercice à la séance'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Exercice>(
                      value: selectedExercice,
                      onChanged: (Exercice? newValue) {
                        setState(() {
                          selectedExercice = newValue;
                        });
                      },
                      items: exercicesProvider.exercices.map((Exercice exercice) {
                        return DropdownMenuItem<Exercice>(
                          value: exercice,
                          child: Text(exercice.name),
                        );
                      }).toList(),
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
                    if (selectedExercice != null) {
                      final newExerciceSeance = ExerciceSeance(
                        exercice: selectedExercice!,
                        temps: isTemps ? temps : null,
                        repetitions: isTemps ? null : repetitions,
                        series: series,
                      );
                      onAdd(newExerciceSeance);
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
}