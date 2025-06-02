class AlimentoModels {
  int? id;
  double? quantidade;
  String nome;
  double energia_kcal;
  double proteinas_g;
  double lipidios_g;
  double glicidios_g;
  double calcio_mg;
  double ferro_mg;
  double vit_a_mmg;
  double vit_c_mg;
  double tiamina_mg;
  double riboflavina_mg;
  double niacina_mg;
  double sodio_mg;
  double fibra_alimentar_g;

  AlimentoModels({
    this.id,
    this.quantidade,
    required this.nome,
    required this.energia_kcal,
    required this.proteinas_g,
    required this.lipidios_g,
    required this.glicidios_g,
    required this.calcio_mg,
    required this.ferro_mg,
    required this.vit_a_mmg,
    required this.vit_c_mg,
    required this.tiamina_mg,
    required this.riboflavina_mg,
    required this.niacina_mg,
    required this.sodio_mg,
    required this.fibra_alimentar_g,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'quantidade': quantidade,
      'nome': nome,
      'energia_kcal': energia_kcal.toString(),
      'proteinas_g': proteinas_g.toString(),
      'lipidios_g': lipidios_g.toString(),
      'glicidios_g': glicidios_g.toString(),
      'calcio_mg': calcio_mg.toString(),
      'ferro_mg': ferro_mg.toString(),
      'vit_a_mmg': vit_a_mmg.toString(),
      'vit_c_mg': vit_c_mg.toString(),
      'tiamina_mg': tiamina_mg.toString(),
      'riboflavina_mg': riboflavina_mg.toString(),
      'niacina_mg': niacina_mg.toString(),
      'sodio_mg': sodio_mg.toString(),
      'fibra_alimentar_g': fibra_alimentar_g.toString(),
    };
  }

  static AlimentoModels fromMap(Map<String, dynamic> map) {
    return AlimentoModels(
      id: map['id'],
      nome: map['nome'] ?? '',
      energia_kcal: double.tryParse(map['energia_kcal'].toString()) ?? 0.0,
      proteinas_g: double.tryParse(map['proteinas_g'].toString()) ?? 0.0,
      lipidios_g: double.tryParse(map['lipidios_g'].toString()) ?? 0.0,
      glicidios_g: double.tryParse(map['glicidios_g'].toString()) ?? 0.0,
      calcio_mg: double.tryParse(map['calcio_mg'].toString()) ?? 0.0,
      ferro_mg: double.tryParse(map['ferro_mg'].toString()) ?? 0.0,
      vit_a_mmg: double.tryParse(map['vit_a_mmg'].toString()) ?? 0.0,
      vit_c_mg: double.tryParse(map['vit_c_mg'].toString()) ?? 0.0,
      tiamina_mg: double.tryParse(map['tiamina_mg'].toString()) ?? 0.0,
      riboflavina_mg: double.tryParse(map['riboflavina_mg'].toString()) ?? 0.0,
      niacina_mg: double.tryParse(map['niacina_mg'].toString()) ?? 0.0,
      sodio_mg: double.tryParse(map['sodio_mg'].toString()) ?? 0.0,
      fibra_alimentar_g:
          double.tryParse(map['fibra_alimentar_g'].toString()) ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'AlimentoModels(id: $id.to, nome: $nome, energia_kcal: ${energia_kcal.toString()}, proteinas_g: $proteinas_g.toString(), lipidios_g $lipidios_g.toString(), glicidios_g $glicidios_g.toString(), calcio_mg $calcio_mg.toString(), ferro_mg $ferro_mg.toString(), vit_a_mmg $vit_a_mmg.toString(), vit_c_mg $vit_c_mg.toString(), tiamina_mg $tiamina_mg.toString(), riboflavina_mg $riboflavina_mg.toString(), niacina_mg $niacina_mg.toString(), sodio_mg $sodio_mg.toString(), fibra_alimentar_g $fibra_alimentar_g.toString())';
  }
}
