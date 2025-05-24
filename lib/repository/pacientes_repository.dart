import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/pacientesModels.dart';

class PacientesRepository {
  late final Future<Database> _db = DB.instance.database;

  Future<void> inserirPacientes(Pacientesmodels paciente) async {
    final db = await _db;
    await db.insert(
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
}
