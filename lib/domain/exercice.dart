class Exercice {
  final String name;
  final int imageIndex;

  const Exercice({required this.name, required this.imageIndex});

  String get imagePath => 'assets/images/exercise${imageIndex + 1}.webp';
}