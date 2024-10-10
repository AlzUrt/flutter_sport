class Exercice {
  final String name;
  final int? imageIndex;
  final String? customImagePath;
  final bool isTemps;
  final Duration? temps;
  final int? repetitions;
  final int series;
  final Duration pauseEntreSeries;

  const Exercice({
    required this.name, 
    this.imageIndex, 
    this.customImagePath,
    required this.isTemps,
    this.temps,
    this.repetitions,
    required this.series,
    required this.pauseEntreSeries,
  });

  String get imagePath => 
    customImagePath ?? 'assets/images/exercise${imageIndex ?? 1}.webp';

  bool get isCustomImage => customImagePath != null;

  @override
  String toString() {
    return 'Exercice(name: $name, isTemps: $isTemps, temps: $temps, repetitions: $repetitions, series: $series)';
  }
}