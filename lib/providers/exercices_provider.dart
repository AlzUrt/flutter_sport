import 'package:flutter/foundation.dart';
import '../domain/exercice.dart';
import '../repositories/exercise_repository.dart';

class ExercicesProvider with ChangeNotifier {
  List<Exercice> _exercices = [];
  final ExerciseRepository _repository = ExerciseRepository();

  List<Exercice> get exercices => _exercices;

  ExercicesProvider() {
    _loadExercices();
  }

  Future<void> _loadExercices() async {
    _exercices = await _repository.getAllExercises();
    notifyListeners();
  }

  Future<void> addExercice(Exercice exercice) async {
    final id = await _repository.insertExercise(exercice);
    exercice = exercice.copyWith(id: id);
    _exercices.add(exercice);
    notifyListeners();
  }

  Future<void> deleteExercice(int index) async {
    final exercice = _exercices[index];
    if (exercice.id != null) {
      await _repository.deleteExercise(exercice.id!);
    }
    _exercices.removeAt(index);
    notifyListeners();
  }

  Future<void> updateExercice(Exercice exercice) async {
    if (exercice.id != null) {
      await _repository.updateExercise(exercice);
      final index = _exercices.indexWhere((e) => e.id == exercice.id);
      if (index != -1) {
        _exercices[index] = exercice;
        notifyListeners();
      }
    }
  }
}