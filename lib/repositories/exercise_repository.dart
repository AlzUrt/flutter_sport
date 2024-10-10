import 'package:sport/services/database_helper.dart';
import 'package:sport/domain/exercice.dart';

class ExerciseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Exercice>> getAllExercises() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Exercise');
    return List.generate(maps.length, (i) {
      return Exercice.fromMap(maps[i]);
    });
  }

  Future<int> insertExercise(Exercice exercice) async {
    final db = await _databaseHelper.database;
    return await db.insert('Exercise', exercice.toMap());
  }

  Future<int> updateExercise(Exercice exercice) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Exercise',
      exercice.toMap(),
      where: 'id = ?',
      whereArgs: [exercice.id],
    );
  }

  Future<int> deleteExercise(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete(
      'Exercise',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}