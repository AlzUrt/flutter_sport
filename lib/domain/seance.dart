import 'package:sport/domain/exercice.dart';

enum SeanceType { AMRAP, EMOM, HIIT }

class ExerciceSeance {
  final Exercice exercice;

  ExerciceSeance({
    required this.exercice,
  });
}

class Seance {
  final String nom;
  final List<Exercice> exercices;
  final SeanceType type;

  Seance({
    required this.nom,
    required this.exercices,
    required this.type,
  });
}