import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'fitness.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Exercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imageIndex INTEGER,
        customImagePath TEXT,
        isTemps INTEGER NOT NULL,
        temps INTEGER,
        repetitions INTEGER,
        series INTEGER NOT NULL,
        pauseEntreSeries INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        rest_between_exercises INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE SessionExercise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exercise_id INTEGER NOT NULL,
        session_id INTEGER NOT NULL,
        FOREIGN KEY (exercise_id) REFERENCES Exercise(id),
        FOREIGN KEY (session_id) REFERENCES Session(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE Comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        session_id INTEGER,
        exercise_id INTEGER,
        FOREIGN KEY (session_id) REFERENCES Session(id),
        FOREIGN KEY (exercise_id) REFERENCES Exercise(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE SessionDate (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        isRecurrent INTEGER NOT NULL,
        recurrence TEXT,
        FOREIGN KEY (session_id) REFERENCES Session(id)
      )
    ''');
  }

  Future<int> insertExercice(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('Exercise', row);
  }

  Future<List<Map<String, dynamic>>> getExercices() async {
    Database db = await database;
    return await db.query('Exercise');
  }

  Future<int> updateExercice(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('Exercise', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExercice(int id) async {
    Database db = await database;
    return await db.delete('Exercise', where: 'id = ?', whereArgs: [id]);
  }
}
