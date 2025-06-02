import 'package:nutri/repository/alimento_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import './../repository/alimento_repository.dart';

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

    await db.execute(_alimentos);
    print("Tabela alimentos criada com sucesso.");
  }

  Future<void> deletarBanco() async {
    final path = join(await getDatabasesPath(), 'nutri_duda.db');
    await deleteDatabase(path);
    print('Banco de dados deletado');
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

  String get _alimentos => '''
CREATE TABLE alimentos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    energia_kcal TEXT,
    proteinas_g TEXT,
    lipidios_g TEXT,
    glicidios_g TEXT,
    calcio_mg TEXT,
    ferro_mg TEXT,
    vit_a_mmg TEXT,
    vit_c_mg TEXT,
    tiamina_mg TEXT,
    riboflavina_mg TEXT,
    niacina_mg TEXT,
    sodio_mg TEXT,
    fibra_alimentar_g TEXT
    );
''';
}
