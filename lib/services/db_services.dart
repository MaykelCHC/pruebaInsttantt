import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Clase Singleton para gestionar la base de datos local SQLite.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  /// Proporciona la instancia única de la clase.
  factory DatabaseService() => _instance;

  static Database? _database;

  /// Obtiene la instancia de la base de datos, inicializándola si es necesario.
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Inicialización perezosa de la base de datos.
    _database = await _initDB();
    return _database!;
  }

  /// Inicializa la base de datos y crea las tablas.
  Future<Database> _initDB() async {
    // Obtiene el camino para la base de datos y lo une con el nombre del archivo.
    String path = p.join(await getDatabasesPath(), 'app_database.db');

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        // Crea las tablas en la base de datos.
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
          idNumber TEXT,
          isAppContact INTEGER DEFAULT 0
        )
      ''');
      },
      version: 1,
      onUpgrade: _migrateDB,
    );
  }

  Future<void> _migrateDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Assuming version 2 includes the `isAppContact` column
      await db.execute('''
      CREATE TABLE new_contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        idNumber TEXT,
        isAppContact INTEGER DEFAULT 0
      )
    ''');

      await db.execute('''
      INSERT INTO new_contacts(id, name, idNumber)
      SELECT id, name, idNumber FROM contacts
    ''');

      await db.execute('DROP TABLE contacts');

      await db.execute('ALTER TABLE new_contacts RENAME TO contacts');
    }
  }
}
