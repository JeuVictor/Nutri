import '../models/dieta_models.dart';
import '../database/db.dart';

class DietaRepository {
  Future<int> insert(DietaModels dieta) async {
    final _db = await DB.instance.database;
    return await _db.insert('dieta', dieta.toMap());
  }

  Future<List<DietaModels>> getAll() async {
    final _db = await DB.instance.database;
    final result = await _db.query('dieta');
    return result.map((e) => DietaModels.fromMap(e)).toList();
  }

  Future<DietaModels?> getById(int id) async {
    final _db = await DB.instance.database;
    final result = await _db.query('dieta', where: 'id = ?', whereArgs: [id]);
    return result.isEmpty ? DietaModels.fromMap(result.first) : null;
  }

  Future<int> detele(int id) async {
    final _db = await DB.instance.database;
    return await _db.delete('dieta', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> joinDieta() async {
    final _db = await DB.instance.database;

    final result = await _db.rawQuery('''
SELECT
  d.id AS dieta_id, d.nome AS dieta_nome, d.data_criacao, d.paciente_id,
  r.id AS refeicao_id, r.nome AS refeicao_nome, r.horario, r.observacoes, r.dieta_id AS refeicao_dieta_id,
  a.id AS refeicao_alimento_id, a.nome AS refeicao_alimento_nome, a.quantidade, a.kcal, a.prot, a.lip, a.glic, a.cal, a.ferro, a.vit_a, a.vit_c, a.tiamina, a.ribo, a.niacina, a.sodio, a.fibras
FROM dieta d
LEFT JOIN refeicao r ON r.dieta_id = d.id
LEFT JOIN refeicao_alimento a ON a.refeicao_id = r.id
ORDER BY d.id, r.id, a.id
''');

    return result;
  }
}
