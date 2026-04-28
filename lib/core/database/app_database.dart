// ============================================================================
//  core/database/app_database.dart
//
//  Base de datos SQLite local usando sqflite.
//  Gestiona las tablas para favoritos y caché de productos.
//  Se registra como Singleton en el contenedor IoC.
// ============================================================================

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  AppDatabase._();

  static final AppDatabase _instance = AppDatabase._();

  /// Devuelve la instancia singleton de la base de datos.
  static Future<AppDatabase> getInstance() async {
    await _instance._initDatabase();
    return _instance;
  }

  Database get database {
    if (_database == null) throw Exception('Database not initialized');
    return _database!;
  }

  Future<void> _initDatabase() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'artesanias_andinas.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Tabla de caché de productos (offline-first)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_products (
        id          INTEGER PRIMARY KEY,
        name        TEXT NOT NULL,
        description TEXT,
        price       REAL NOT NULL,
        category    TEXT,
        imageUrl    TEXT,
        stock       INTEGER DEFAULT 0,
        artisan     TEXT,
        origin      TEXT,
        cachedAt    INTEGER NOT NULL
      )
    ''');

    // Tabla de favoritos del usuario
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        productId   INTEGER NOT NULL UNIQUE,
        productName TEXT NOT NULL,
        addedAt     INTEGER NOT NULL
      )
    ''');

    // Tabla de usuarios (caché de sesión)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cached_user (
        id       TEXT PRIMARY KEY,
        name     TEXT NOT NULL,
        email    TEXT NOT NULL,
        role     TEXT DEFAULT 'customer',
        token    TEXT
      )
    ''');
  }
}
