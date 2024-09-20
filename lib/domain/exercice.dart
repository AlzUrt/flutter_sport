class Exercice {
  final String name;
  final int? imageIndex;
  final String? customImagePath;

  const Exercice({
    required this.name, 
    this.imageIndex, 
    this.customImagePath
  }) : assert(imageIndex != null || customImagePath != null);

  String get imagePath => 
    customImagePath ?? 'assets/images/exercise${imageIndex! + 1}.webp';

  bool get isCustomImage => customImagePath != null;
}