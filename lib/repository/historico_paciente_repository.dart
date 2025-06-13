import 'package:nutri/models/dieta_models.dart';
import 'package:nutri/models/pacientesModels.dart';
import 'package:nutri/models/refeicao_alimentos_models.dart';
import 'package:nutri/models/refeicao_models.dart';
import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/historico_paciente_models.dart';
import '../models/histotico_completo_model.dart';

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
    print('Atualizado o db ${historico}');
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

  Future<HistoticoCompletoModel?> getHistoricoCompleto(int historicoId) async {
    final db = await DB.instance.database;
    final String joinQuery = '''
      SELECT
        hp.*,
        p.id AS paciente_id,
        p.nome AS paciente_nome,
        p.celular AS paciente_celular,
        p.email AS paciente_email,
        p.data_nasc AS paciente_data_nasc,
        p.sexo AS paciente_sexo,
        p.altura AS paciente_altura,
        p.peso AS paciente_peso,
        p.peso_alvo AS paciente_peso_alvo,
        p.gordura AS paciente_gordura,
        p.musculo AS paciente_musculo,
        p.data_criacao AS paciente_data_criacao,
        p.nivel_atividade AS paciente_nivel_atividade,
        d.id AS dieta_id, d.nome AS dieta_nome,
        r.id AS refeicao_id, r.nome AS refeicao_nome, r.horario, r.observacoes, 
        ra.*
      FROM historico_paciente hp
      JOIN paciente p ON p.id = hp.paciente_id
      LEFT JOIN dieta d ON d.id = hp.dieta_id
      LEFT JOIN refeicao r ON r.dieta_id = d.id
      LEFT JOIN refeicao_alimento ra ON ra.refeicao_id = r.id
      WHERE hp.id = ?;
    ''';
    final result = await db.rawQuery(joinQuery, [historicoId]);

    if (result.isEmpty) return null;
    final firstRow = result.first;

    final historico = HistoricoPaciente.fromJoinMap(firstRow);
    final paciente = Pacientesmodels.fromJoinedMap(firstRow);

    DietaModels? dieta;
    if (firstRow['dieta_id'] != null) {
      dieta = DietaModels.fromJoinMap(firstRow);
    }

    final Map<int, RefeicaoCompleta> refeicoesMap = {};

    for (var row in result) {
      final int? refeicaoId = row['refeicao_id'] as int?;
      if (refeicaoId == null) continue;

      if (!refeicoesMap.containsKey(refeicaoId)) {
        final refeicao = RefeicaoModels(
          id: refeicaoId,
          nome: row['refeicao_nome'] as String,
          horario: row['horario'] as String,
          observacoes: row['observacoes'] as String,
          dietaId: row['dieta_id'] as int,
        );

        refeicoesMap[refeicaoId] = RefeicaoCompleta(
          alimentos: [],
          refeicao: refeicao,
        );
      }

      final int? alimentoId = row['alimento_id'] as int?;
      if (alimentoId != null) {
        final alimento = RefeicaoAlimentosModels.fromJoinMap(row);
        refeicoesMap[refeicaoId]!.alimentos.add(alimento);
      }
    }

    return HistoticoCompletoModel(
      dieta: dieta,
      historico: historico,
      paciente: paciente,
      refeicoes: refeicoesMap.values.toList(),
    );
  }
}
