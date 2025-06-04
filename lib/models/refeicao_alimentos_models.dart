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
