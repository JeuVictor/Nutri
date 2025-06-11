import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/pacientesModels.dart';

class PacientesRepository {
  late final Future<Database> _db = DB.instance.database;

  Future<int> inserirPacientes(Pacientesmodels paciente) async {
    final db = await _db;
    return await db.insert(
      'paciente',
      paciente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pacientesmodels>> listarPacientes() async {
    final db = await _db;
    final maps = await db.query('paciente');
    return maps.map((e) => Pacientesmodels.fromMap(e)).toList();
  }

  Future<void> deletarPaciente(int id) async {
    final db = await _db;
    await db.delete('paciente', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> atualizarPaciente(Pacientesmodels paciente) async {
    final db = await _db;
    await db.update(
      'paciente',
      paciente.toMap(),
      where: 'id = ?',
      whereArgs: [paciente.id],
    );
  }

  Future<Pacientesmodels?> obterPacientesPorId(int id) async {
    final db = await _db;
    final resultado = await db.query(
      'paciente',
      where: 'id=?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      return Pacientesmodels.fromMap(resultado.first);
    }
    return null;
  }

  Future<List<Pacientesmodels>> buscarPacientes(String filtro) async {
    final db = await _db;
    final filtroFormado = '%$filtro%';

    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    whereClauses.add('nome LIKE ?');
    whereArgs.add(filtroFormado);
    whereClauses.add('celular LIKE ?');
    whereArgs.add(filtroFormado);
    whereClauses.add('email LIKE ?');
    whereArgs.add(filtroFormado);

    final idade = int.tryParse(filtro);
    if (idade != null) {
      final hoje = DateTime.now();

      final dataLimiteSup = DateTime(hoje.year - idade, hoje.month, hoje.day);
      final dataLimiteInf = DateTime(
        hoje.year - idade - 1,
        hoje.month,
        hoje.day,
      ).add(Duration(days: 1));

      final dataSuperior = dataLimiteSup.toIso8601String().substring(0, 10);
      final dataInferior = dataLimiteInf.toIso8601String().substring(0, 10);

      whereClauses.add('(data_nasc BETWEEN ? AND ?)');
      whereArgs.addAll([dataInferior, dataSuperior]);
    }

    final resultado = await db.query(
      'paciente',
      where: whereClauses.join(' OR '),
      whereArgs: whereArgs,
    );
    return resultado.map((e) => Pacientesmodels.fromMap(e)).toList();
  }
}
