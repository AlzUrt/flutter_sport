import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport/domain/exercise.dart';
import 'package:sport/widgets/custom_button.dart';
import '../providers/sessions_provider.dart';
import '../providers/exercises_provider.dart';
import '../domain/session.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SessionsProvider>(
        builder: (context, sessionsProvider, child) {
          return ListView.builder(
            itemCount: sessionsProvider.sessions.length,
            itemBuilder: (context, index) {
              final session = sessionsProvider.sessions[index];
              return ListTile(
                title: Text(session.nom),
                subtitle: Text(
                    '${session.exercises.length} exercises - ${session.type.toString().split('.').last}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => sessionsProvider.deleteSession(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: CustomButton(
        icon: Icons.add,
        width: MediaQuery.of(context).size.width - 32,
        height: 60,
        onPressed: () {
          _showAddSessionForm(context);
        },
      ),
    );
  }

  void _showAddSessionForm(BuildContext context) {
    final exercisesProvider =
        Provider.of<ExercisesProvider>(context, listen: false);

    String nom = '';
    List<Exercise> selectedExercises = [];
    Duration pauseEntreExercises = Duration.zero;
    SessionType type = SessionType.AMRAP;

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
                      decoration:
                          const InputDecoration(labelText: 'Nom de la séance'),
                      onChanged: (value) => nom = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _showAddExercisesToSessionForm(
                          context, exercisesProvider, selectedExercises,
                          (updatedExercises) {
                        setState(() {
                          selectedExercises = updatedExercises;
                        });
                      }),
                      child: const Text('Gérer les exercises'),
                    ),
                    const SizedBox(height: 10),
                    Text('Exercises ajoutés: ${selectedExercises.length}'),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<SessionType>(
                      value: type,
                      onChanged: (SessionType? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                      items: SessionType.values.map((SessionType sessionType) {
                        return DropdownMenuItem<SessionType>(
                          value: sessionType,
                          child: Text(sessionType.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                        'Pause entre exercises: ${pauseEntreExercises.inSeconds} secondes'),
                    Slider(
                      value: pauseEntreExercises.inSeconds.toDouble(),
                      min: 0,
                      max: 300,
                      divisions: 60,
                      label: pauseEntreExercises.inSeconds.toString(),
                      onChanged: (double value) {
                        setState(() {
                          pauseEntreExercises =
                              Duration(seconds: value.round());
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
                    if (nom.isNotEmpty && selectedExercises.isNotEmpty) {
                      final newSession = Session(
                        nom: nom,
                        exercises: selectedExercises,
                        type: type,
                      );
                      Provider.of<SessionsProvider>(context, listen: false)
                          .addSession(newSession);
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

  void _showAddExercisesToSessionForm(
      BuildContext context,
      ExercisesProvider exercisesProvider,
      List<Exercise> initialSelectedExercises,
      Function(List<Exercise>) onUpdate) {
    List<Exercise> selectedExercises = List.from(initialSelectedExercises);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Gérer les exercises de la séance'),
              content: Container(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: exercisesProvider.exercises
                            .map((exercise) => CheckboxListTile(
                                  title: Text(exercise.name),
                                  value: selectedExercises.contains(exercise),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        if (!selectedExercises
                                            .contains(exercise)) {
                                          selectedExercises.add(exercise);
                                        }
                                      } else {
                                        selectedExercises.remove(exercise);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    const Divider(),
                    const Text(
                        'Exercises sélectionnés (glisser "=" pour réordonner):'),
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: selectedExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = selectedExercises[index];
                          return Card(
                            key: ValueKey(exercise),
                            child: ListTile(
                              title: Text(exercise.name),
                              trailing: ReorderableDragStartListener(
                                index: index,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onPanUpdate: (details) {
                                    // Cette fonction sera appelée lors du glissement
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
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
                            final Exercise item =
                                selectedExercises.removeAt(oldIndex);
                            selectedExercises.insert(newIndex, item);
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
                    onUpdate(selectedExercises);
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
