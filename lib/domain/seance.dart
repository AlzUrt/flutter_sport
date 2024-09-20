import 'package:sport/domain/exercice.dart';

enum SeanceType { AMRAP, EMOM, HIIT }

class ExerciceSeance {
  final Exercice exercice;
  final Duration? temps;
  final int? repetitions;
  final int series;

  ExerciceSeance({
    required this.exercice,
    this.temps,
    this.repetitions,
    required this.series,
  }) : assert(temps != null || repetitions != null);
}

class Seance {
  final String nom;
  final List<ExerciceSeance> exercices;
  final Duration pauseEntreSeries;
  final Duration pauseEntreExercices;
  final SeanceType type;

  Seance({
    required this.nom,
    required this.exercices,
    required this.pauseEntreSeries,
    required this.pauseEntreExercices,
    required this.type,
  });
}