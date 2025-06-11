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

    await db.execute(_alimentos);
    print("Tabela alimentos criada com sucesso.");

    await db.execute(_dieta);
    print("Tabela de dieta criada");

    await db.execute(_refeicao);
    print("Tabela de _refeicao criada");

    await db.execute(_refeicaoAlimento);
    print("Tabela de _refeicao_Alimento criada");

    await db.execute(_usuario);
    print("Tabela de _usuario criada");
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
      data_nasc TEXT,
      sexo TEXT, 
      altura INTEGER,      
      peso REAL,
      gordura REAL,
      musculo REAL,
      nivel_atividade TEXT, 
      data_criacao TEXT
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

  String get _dieta => '''
  CREATE TABLE dieta(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    data_criacao TEXT,
    paciente_id INTEGER,
    FOREIGN KEY (paciente_id) REFERENCES paciente(id)
  );
''';
  String get _refeicao => '''
CREATE TABLE refeicao(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT,
  horario TEXT,
  observacoes TEXT,
  dieta_id INTEGER,
  FOREIGN KEY (dieta_id) REFERENCES dieta(id)
);
''';
  String get _refeicaoAlimento => '''
CREATE TABLE refeicao_alimento(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  refeicao_id INTEGER,
  alimento_id INTEGER,
    nome TEXT,
    quantidade REAL,
    kcal REAL,
    prot REAL,
    lip REAL,
    glic REAL,
    cal REAL,
    ferro REAL,
    vit_a REAL,
    vit_c REAL,
    tiamina REAL,
    ribo REAL,
    niacina REAL,
    sodio REAL,
    fibras REAL,
    FOREIGN KEY (refeicao_id) REFERENCES refeicao(id),
    FOREIGN KEY (alimento_id) REFERENCES alimentos(id)
);
''';

  String get _usuario => '''
  CREATE TABLE usuario(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    crn TEXT NOT NULL,
    telefone TEXT NOT NULL,
    email TEXT,
    esp TEXT,
    endereco TEXT,
    caminhoImg TEXT,
    corTema TEXT
  );
''';
}
