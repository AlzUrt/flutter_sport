import 'package:flutter/foundation.dart';
import '../domain/exercice.dart';
import '../services/database_helper.dart';

class ExercicesProvider with ChangeNotifier {
  List<Exercice> _exercices = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  List<Exercice> get exercices => _exercices;

  ExercicesProvider() {
    _loadExercices();
  }

  Future<void> _loadExercices() async {
    final exercicesData = await _databaseHelper.getExercices();
    _exercices = exercicesData.map((e) => Exercice.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addExercice(Exercice exercice) async {
    final id = await _databaseHelper.insertExercice(exercice.toMap());
    exercice = Exercice(
      id: id,
      name: exercice.name,
      imageIndex: exercice.imageIndex,
      customImagePath: exercice.customImagePath,
      isTemps: exercice.isTemps,
      temps: exercice.temps,
      repetitions: exercice.repetitions,
      series: exercice.series,
      pauseEntreSeries: exercice.pauseEntreSeries,
    );
    _exercices.add(exercice);
    notifyListeners();
  }

  Future<void> deleteExercice(int index) async {
    final exercice = _exercices[index];
    if (exercice.id != null) {
      await _databaseHelper.deleteExercice(exercice.id!);
    }
    _exercices.removeAt(index);
    notifyListeners();
  }

  Future<void> updateExercice(Exercice exercice) async {
    if (exercice.id != null) {
      await _databaseHelper.updateExercice(exercice.toMap());
      final index = _exercices.indexWhere((e) => e.id == exercice.id);
      if (index != -1) {
        _exercices[index] = exercice;
        notifyListeners();
      }
    }
  }
}