import 'package:sport/services/database_helper.dart';
import 'package:sport/domain/exercise.dart';

class ExerciseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Exercise>> getAllExercises() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Exercise');
    return List.generate(maps.length, (i) {
      return Exercise.fromMap(maps[i]);
    });
  }

  Future<int> insertExercise(Exercise exercise) async {
    final db = await _databaseHelper.database;
    return await db.insert('Exercise', exercise.toMap());
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'Exercise',
      exercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
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
