import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/person.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'people.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE people(
            id INTEGER PRIMARY KEY,
            name TEXT,
            profilePath TEXT,
            popularity REAL
          )
        ''');
      },
    );
  }

  Future<void> insertPerson(Person person) async {
    final db = await database;
    await db.insert(
      'people',
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> getAllPeople() async {
    final db = await database;
    final List<Map<String, dynamic>> peopleMaps = await db.query('people');

    return List.generate(peopleMaps.length, (i) {
      return Person.fromJson(peopleMaps[i]);
    });
  }

  Future<void> deleteAllPeople() async {
    final db = await database;
    await db.delete('people');
  }
}
