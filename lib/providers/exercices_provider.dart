import 'package:flutter/foundation.dart';
import '../domain/exercice.dart';

class ExercicesProvider with ChangeNotifier {
  final List<Exercice> _exercices = [];

  List<Exercice> get exercices => _exercices;

  void addExercice(Exercice exercice) {
    _exercices.add(exercice);
    notifyListeners();
  }

  void deleteExercice(int index) {
    _exercices.removeAt(index);
    notifyListeners();
  }
}