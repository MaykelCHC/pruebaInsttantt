import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Singleton class to manage the local SQLite database.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Lazy initialization of the database.
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = p.join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        // Create tables.
        await db.execute('''
          CREATE TABLE users(
            username TEXT PRIMARY KEY,
            email TEXT,
            password TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            idNumber TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Additional CRUD methods for User and Contact...
}
