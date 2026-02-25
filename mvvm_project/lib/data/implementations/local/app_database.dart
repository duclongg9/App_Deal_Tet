import 'package:mvvm_project/data/implementations/local/password_hasher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mvvm_project.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await _createSchema(db);
        await _seedUsers(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE user ADD COLUMN role TEXT NOT NULL DEFAULT 'user'");
          await db.update('user', {'role': 'admin'}, where: 'username = ?', whereArgs: ['admin']);
          await _seedUsers(db);
        }
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'user'
      );
    ''');

    await db.execute('''
      CREATE TABLE session (
        id INTEGER PRIMARY KEY CHECK(id = 1),
        user_id INTEGER NOT NULL,
        token TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES user(id)
      );
    ''');
  }

  Future<void> _seedUsers(Database db) async {
    await db.insert(
      'user',
      {
        'username': 'admin',
        'password_hash': PasswordHasher.sha256Hash('FU@2026'),
        'role': 'admin',
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    await db.insert(
      'user',
      {
        'username': 'longpham',
        'password_hash': PasswordHasher.sha256Hash('12345'),
        'role': 'user',
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
