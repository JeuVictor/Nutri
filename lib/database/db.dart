import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'nutri_duda.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Criando Banco de dados');
    await db.execute(_paciente);
    print("Tabela Paciente criada com sucesso.");
  }

  String get _paciente => '''
    CREATE TABLE paciente(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      celular TEXT,
      email TEXT,
      idade INTEGER,
      sexo TEXT, 
      altura INTEGER,      
      peso REAL,
      gordura REAL,
      musculo REAL 
    );
  ''';
}
