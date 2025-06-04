import 'package:sqflite/sqflite.dart';
import './../database/db.dart';
import './../database/composicao_alimentos.dart';
import '../models/alimento_models.dart';

class AlimentoRepository {
  late final Future<Database> _db = DB.instance.database;

  Future<void> inserirAlimento(AlimentoModels alimento) async {
    final db = await _db;
    await db.insert(
      'alimentos',
      alimento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AlimentoModels>> listarAlimentos() async {
    final db = await _db;
    final maps = await db.query('alimentos');
    return maps.map((e) => AlimentoModels.fromMap(e)).toList();
  }

  Future<void> deletarAlimentos(int id) async {
    final db = await _db;
    await db.delete('alimentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> atualizarAlimento(AlimentoModels alimento) async {
    final db = await _db;
    await db.update(
      'alimentos',
      alimento.toMap(),
      where: 'id = ?',
      whereArgs: [alimento.id],
    );
  }

  Future<AlimentoModels?> obterAlimentosPorId(int id) async {
    final db = await _db;
    final resultado = await db.query(
      'alimentos',
      where: 'id=?',
      whereArgs: [id],
    );

    if (resultado.isNotEmpty) {
      return AlimentoModels.fromMap(resultado.first);
    }
    return null;
  }

  Future<List<AlimentoModels>> buscarAlimentos(String filtro) async {
    final db = await _db;
    final filtroFormado = '%$filtro%';

    final resultado = await db.query(
      'alimentos',
      where: '''
    nome LIKE ? OR
    CAST(energia_kcal AS TEXT) LIKE ? OR
    proteinas_g LIKE ? OR
    lipidios_g LIKE ?
''',
      whereArgs: [filtroFormado, filtroFormado, filtroFormado, filtroFormado],
    );
    return resultado.map((e) => AlimentoModels.fromMap(e)).toList();
  }

  Future<List<AlimentoModels>> buscaAvancada({
    required String campo,
    required double minimo,
    required double maximo,
  }) async {
    final db = await _db;

    final resultado = await db.query(
      'alimentos',
      where: 'CAST($campo AS REAL) BETWEEN ? AND ?',
      whereArgs: [minimo, maximo],
    );

    return resultado.map((e) => AlimentoModels.fromMap(e)).toList();
  }
}

Future<void> popularTabelaAlimentos() async {
  try {
    final db = await DB.instance.database;

    for (var alimento in composicaoQuimicaAlimentos) {
      await db.insert("alimentos", {
        'nome': alimento["Alimento"] ?? '',
        'energia_kcal': alimento["Energia (kcal)"] ?? '',
        'proteinas_g': alimento["Proteínas (g)"] ?? '',
        'lipidios_g': alimento["Lipídios (g)"] ?? '',
        'glicidios_g': alimento["Glicídios (g)"] ?? '',
        'calcio_mg': alimento["Cálcio (mg)"] ?? '',
        'ferro_mg': alimento["Ferro (mg)"] ?? '',
        'vit_a_mmg': alimento["Vit A (mmg)"] ?? '',
        'vit_c_mg': alimento["Vit C (mg)"] ?? '',
        'tiamina_mg': alimento["Tiamina (mg)"] ?? '',
        'riboflavina_mg': alimento["Riboflavina (mg)"] ?? '',
        'niacina_mg': alimento["Niacina (mg)"] ?? '',
        'sodio_mg': alimento["Sódio (mg)"] ?? '',
        'fibra_alimentar_g': alimento["Fibra alimentar (g)"] ?? '',
      });
    }
    print('Tabela Alimentos populada com sucesso!');
  } catch (e) {
    print('Erro ao popular a tabela alimentos: $e');
  }
}
