class Exercice {
  final int? id;
  final String name;
  final int? imageIndex;
  final String? customImagePath;
  final bool isTemps;
  final Duration? temps;
  final int? repetitions;
  final int series;
  final Duration pauseEntreSeries;

  Exercice({
    this.id,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageIndex': imageIndex,
      'customImagePath': customImagePath,
      'isTemps': isTemps ? 1 : 0,
      'temps': temps?.inSeconds,
      'repetitions': repetitions,
      'series': series,
      'pauseEntreSeries': pauseEntreSeries.inSeconds,
    };
  }

  factory Exercice.fromMap(Map<String, dynamic> map) {
    return Exercice(
      id: map['id'],
      name: map['name'],
      imageIndex: map['imageIndex'],
      customImagePath: map['customImagePath'],
      isTemps: map['isTemps'] == 1,
      temps: map['temps'] != null ? Duration(seconds: map['temps']) : null,
      repetitions: map['repetitions'],
      series: map['series'],
      pauseEntreSeries: Duration(seconds: map['pauseEntreSeries']),
    );
  }

  Exercice copyWith({
    int? id,
    String? name,
    int? imageIndex,
    String? customImagePath,
    bool? isTemps,
    Duration? temps,
    int? repetitions,
    int? series,
    Duration? pauseEntreSeries,
  }) {
    return Exercice(
      id: id ?? this.id,
      name: name ?? this.name,
      imageIndex: imageIndex ?? this.imageIndex,
      customImagePath: customImagePath ?? this.customImagePath,
      isTemps: isTemps ?? this.isTemps,
      temps: temps ?? this.temps,
      repetitions: repetitions ?? this.repetitions,
      series: series ?? this.series,
      pauseEntreSeries: pauseEntreSeries ?? this.pauseEntreSeries,
    );
  }

  @override
  String toString() {
    return 'Exercice(id: $id, name: $name, isTemps: $isTemps, temps: $temps, repetitions: $repetitions, series: $series)';
  }
}