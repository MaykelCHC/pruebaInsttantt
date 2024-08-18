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
            idNumber TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Métodos adicionales CRUD para User y Contact...
}
