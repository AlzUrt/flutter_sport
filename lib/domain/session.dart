import 'package:sport/domain/exercise.dart';

enum SessionType { AMRAP, EMOM, HIIT }

class ExerciseSession {
  final Exercise exercise;

  ExerciseSession({
    required this.exercise,
  });
}

class Session {
  final String nom;
  final List<Exercise> exercises;
  final SessionType type;

  Session({
    required this.nom,
    required this.exercises,
    required this.type,
  });
}
