import 'package:nutri/models/dieta_models.dart';
import 'package:nutri/models/historico_paciente_models.dart';
import 'package:nutri/models/refeicao_alimentos_models.dart';
import 'package:nutri/models/refeicao_models.dart';

import 'pacientesModels.dart';

class HistoticoCompletoModel {
  final HistoricoPaciente historico;
  final Pacientesmodels paciente;
  final DietaModels? dieta;
  final List<RefeicaoCompleta>? refeicoes;

  HistoticoCompletoModel({
    required this.dieta,
    required this.historico,
    required this.paciente,
    required this.refeicoes,
  });
}

class RefeicaoCompleta {
  final RefeicaoModels refeicao;
  final List<RefeicaoAlimentosModels> alimentos;

  RefeicaoCompleta({required this.alimentos, required this.refeicao});
}
