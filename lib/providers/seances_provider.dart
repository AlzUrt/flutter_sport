import 'package:flutter/foundation.dart';
import '../domain/seance.dart';

class SeancesProvider with ChangeNotifier {
  final List<Seance> _seances = [];

  List<Seance> get seances => _seances;

  void addSeance(Seance seance) {
    _seances.add(seance);
    notifyListeners();
  }

  void deleteSeance(int index) {
    _seances.removeAt(index);
    notifyListeners();
  }
}