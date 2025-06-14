class RefeicaoAlimentosModels {
  final int? id;
  final int refeicaoId;
  final int alimentoId;
  final String nome;
  final double quantidade;
  final double kcal;
  final double prot;
  final double lip;
  final double glic;
  final double cal;
  final double ferro;
  final double vitA;
  final double vitC;
  final double tiamina;
  final double ribo;
  final double niacina;
  final double sodio;
  final double fibras;

  RefeicaoAlimentosModels({
    this.id,
    required this.refeicaoId,
    required this.alimentoId,
    required this.nome,
    required this.quantidade,
    required this.kcal,
    required this.prot,
    required this.lip,
    required this.glic,
    required this.cal,
    required this.ferro,
    required this.vitA,
    required this.vitC,
    required this.tiamina,
    required this.ribo,
    required this.niacina,
    required this.sodio,
    required this.fibras,
  });

  factory RefeicaoAlimentosModels.fromMap(Map<String, dynamic> map) {
    return RefeicaoAlimentosModels(
      id: map['id'],
      refeicaoId: map['refeicaoId'],
      alimentoId: map['alimentoId'],
      nome: map['nome'],
      quantidade: map['quantidade'],
      kcal: map['kcal'],
      prot: map['prot'],
      lip: map['lip'],
      glic: map['glic'],
      cal: map['cal'],
      ferro: map['ferro'],
      vitA: map['vitA'],
      vitC: map['vitC'],
      tiamina: map['tiamina'],
      ribo: map['ribo'],
      niacina: map['niacina'],
      sodio: map['sodio'],
      fibras: map['fibras'],
    );
  }
  factory RefeicaoAlimentosModels.fromJoinMap(Map<String, dynamic> map) {
    print('DEBUG Alimento JOIN => $map'); // Ajuda a entender o que veio nulo

    return RefeicaoAlimentosModels(
      id: map['refeicao_alimento_id'] ?? 0,
      refeicaoId: map['refeicaoId'] ?? 0,
      alimentoId: map['alimentoId'] ?? 0,
      nome: map['refeicao_alimento_nome'] ?? 'Sem nome',
      quantidade: (map['quantidade'] ?? 0).toDouble(),
      kcal: (map['kcal'] ?? 0).toDouble(),
      prot: (map['prot'] ?? 0).toDouble(),
      lip: (map['lip'] ?? 0).toDouble(),
      glic: (map['glic'] ?? 0).toDouble(),
      cal: (map['cal'] ?? 0).toDouble(),
      ferro: (map['ferro'] ?? 0).toDouble(),
      vitA: (map['vitA'] ?? 0).toDouble(),
      vitC: (map['vitC'] ?? 0).toDouble(),
      tiamina: (map['tiamina'] ?? 0).toDouble(),
      ribo: (map['ribo'] ?? 0).toDouble(),
      niacina: (map['niacina'] ?? 0).toDouble(),
      sodio: (map['sodio'] ?? 0).toDouble(),
      fibras: (map['fibras'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'refeicao_id': refeicaoId,
      'alimento_id': alimentoId,
      'nome': nome,
      'quantidade': quantidade,
      'kcal': kcal,
      'prot': prot,
      'lip': lip,
      'glic': glic,
      'cal': cal,
      'ferro': ferro,
      'vit_a': vitA,
      'vit_c': vitC,
      'tiamina': tiamina,
      'ribo': ribo,
      'niacina': niacina,
      'sodio': sodio,
      'fibras': fibras,
    };
  }
}
