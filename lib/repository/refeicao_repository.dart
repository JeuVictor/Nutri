import '../models/refeicao_models.dart';
import '../database/db.dart';

class RefeicaoRepository {
  Future<int> insert(RefeicaoModels refeicao) async {
    final _db = await DB.instance.database;
    return await _db.insert('refeicao', refeicao.toMap());
  }

  Future<List<RefeicaoModels>> retornarTudo(int dietaId) async {
    final _db = await DB.instance.database;
    final result = await _db.query(
      'refeicao',
      where: 'dieta_id = ?',
      whereArgs: [dietaId],
    );
    return result.map((e) => RefeicaoModels.fromMap(e)).toList();
  }

  Future<RefeicaoModels?> buscarId(int id) async {
    final _db = await DB.instance.database;
    final result = await _db.query(
      'refeicao',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? RefeicaoModels.fromMap(result.first) : null;
  }

  Future<int> delete(int id) async {
    final _db = await DB.instance.database;
    return await _db.delete('refeicao', where: 'id = ?', whereArgs: [id]);
  }
}
