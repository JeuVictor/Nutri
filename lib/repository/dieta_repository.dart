
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
}
