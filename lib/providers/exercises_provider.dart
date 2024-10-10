import 'package:flutter/foundation.dart';
import '../domain/exercise.dart';
import '../repositories/exercise_repository.dart';

class ExercisesProvider with ChangeNotifier {
  List<Exercise> _exercises = [];
  final ExerciseRepository _repository = ExerciseRepository();

  List<Exercise> get exercises => _exercises;

  ExercisesProvider() {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    _exercises = await _repository.getAllExercises();
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    final id = await _repository.insertExercise(exercise);
    exercise = exercise.copyWith(id: id);
    _exercises.add(exercise);
    notifyListeners();
  }

  Future<void> deleteExercise(int index) async {
    final exercise = _exercises[index];
    if (exercise.id != null) {
      await _repository.deleteExercise(exercise.id!);
    }
    _exercises.removeAt(index);
    notifyListeners();
  }

  Future<void> updateExercise(Exercise exercise) async {
    if (exercise.id != null) {
      await _repository.updateExercise(exercise);
      final index = _exercises.indexWhere((e) => e.id == exercise.id);
      if (index != -1) {
        _exercises[index] = exercise;
        notifyListeners();
      }
    }
  }
}
