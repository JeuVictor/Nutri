import '../models/refeicao_alimentos_models.dart';
import '../database/db.dart';

class RefeicaoAlimentoRepository {
  Future<int> insert(RefeicaoAlimentosModels model) async {
    final _db = await DB.instance.database;
    return await _db.insert('refeicao_alimento', model.toMap());
  }

  Future<List<RefeicaoAlimentosModels>> todosResultados(int refeicaoId) async {
    final _db = await DB.instance.database;
    final result = await _db.query(
      'refeicao_alimento',
      where: 'refeicao_id = ?',
      whereArgs: [refeicaoId],
    );
    return result.map((e) => RefeicaoAlimentosModels.fromMap(e)).toList();
  }

  Future<RefeicaoAlimentosModels?> buscaPorId(int id) async {
    final _db = await DB.instance.database;
    final result = await _db.query(
      'refeicao_alimento',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty
        ? RefeicaoAlimentosModels.fromMap(result.first)
        : null;
  }

  Future<int> delete(int id) async {
    final _db = await DB.instance.database;
    return await _db.delete(
      'refeicao_alimento',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(RefeicaoAlimentosModels model) async {
    final _db = await DB.instance.database;
    return await _db.update(
      'refeicao_alimento',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }
}
