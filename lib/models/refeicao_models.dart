class RefeicaoModels {
  final int? id;
  final String nome;
  final String horario;
  final String observacoes;
  final int dietaId;

  RefeicaoModels({
    this.id,
    required this.nome,
    required this.horario,
    required this.observacoes,
    required this.dietaId,
  });

  factory RefeicaoModels.fromMap(Map<String, dynamic> map) {
    return RefeicaoModels(
      nome: map['nome'],
      horario: map['horario'],
      observacoes: map['observacoes'],
      dietaId: map['dietaId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'horario': horario,
      'observacoes': observacoes,
      'dieta_id': dietaId,
    };
  }
}
