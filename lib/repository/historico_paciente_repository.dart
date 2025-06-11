import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/historico_paciente_models.dart';

class HistoricoPacienteRepository {
  Future<Database> get _db async => await DB.instance.database;
  final String _table = 'historico_paciente';

  Future<int> inserir(HistoricoPaciente historico) async {
    final db = await _db;

    return await db.insert(
      _table,
      historico.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HistoricoPaciente>> buscarPorPaciente(int pacienteId) async {
    final db = await _db;
    final maps = await db.query(
      _table,
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_att DESC',
    );

    return maps.map((map) => HistoricoPaciente.fromMap(map)).toList();
  }

  Future<HistoricoPaciente?> buscaId(int id) async {
    final db = await _db;
    final maps = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return HistoricoPaciente.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletar(int id) async {
    final db = await _db;
    return await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> atualizar(HistoricoPaciente historico) async {
    final db = await _db;
    return await db.update(
      _table,
      historico.toMap(),
      where: 'id = ?',
      whereArgs: [historico.id],
    );
  }

  Future<HistoricoPaciente?> buscarUltimoHistPaciente(int pacienteId) async {
    final db = await _db;
    final maps = await db.query(
      _table,
      where: 'paciente_id = ?',
      whereArgs: [pacienteId],
      orderBy: 'data_att DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return HistoricoPaciente.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
