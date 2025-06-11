class HistoricoPaciente {
  final int? id;
  final int pacienteId;
  final int? dietaId;
  final int? nutriId;

  final double peso;
  final double? gordura;
  final double? musculo;
  final String nivelAtv;

  final double? imc;
  final double? img;
  final double? pesoAlvo;

  final String? obs;
  final String dataAtt;

  HistoricoPaciente({
    this.id,
    required this.pacienteId,
    required this.peso,
    required this.nivelAtv,
    required this.dataAtt,
    this.dietaId,
    this.gordura,
    this.imc,
    this.img,
    this.musculo,
    this.nutriId,
    this.obs,
    this.pesoAlvo,
  });

  factory HistoricoPaciente.fromMap(Map<String, dynamic> map) {
    return HistoricoPaciente(
      pacienteId: map['paciente_id'],
      peso: map['peso'],
      nivelAtv: map['nivel_atv'],
      dataAtt: map['data_att'],
      id: map['id'],
      dietaId: map['dieta_id'],
      gordura: map['gordura'],
      imc: map['imc'],
      img: map['img'],
      musculo: map['musculo'],
      nutriId: map['nutri_id'],
      obs: map['obs'],
      pesoAlvo: map['peso_alvo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'peso': peso,
      'nivel_atv': nivelAtv,
      'data_att': dataAtt,
      'dieta_id': dietaId,
      'gordura': gordura,
      'imc': imc,
      'img': img,
      'musculo': musculo,
      'nutri_id': nutriId,
      'obs': obs,
      'peso_alvo': pesoAlvo,
    };
  }

  HistoricoPaciente copyWith({
    int? id,
    int? pacienteId,
    int? dietaId,
    int? nutriId,

    double? peso,
    double? gordura,
    double? musculo,
    String? nivelAtv,

    double? imc,
    double? img,
    double? pesoAlvo,

    String? obs,
    String? dataAtt,
  }) {
    return HistoricoPaciente(
      id: id ?? this.id,
      pacienteId: pacienteId ?? this.pacienteId,
      peso: peso ?? this.peso,
      nivelAtv: nivelAtv ?? this.nivelAtv,
      dataAtt: dataAtt ?? this.dataAtt,
      dietaId: dietaId ?? this.dietaId,
      gordura: gordura ?? this.gordura,
      imc: imc ?? this.imc,
      img: img ?? this.img,
      musculo: musculo ?? this.musculo,
      nutriId: nutriId ?? this.nutriId,
      obs: obs ?? this.obs,
      pesoAlvo: pesoAlvo ?? this.pesoAlvo,
    );
  }

  @override
  String toString() {
    return 'HistoricoPaciente(id: $id, pacienteId: $pacienteId, peso: $peso, nivelAtv: $nivelAtv, dataAtt: $dataAtt)';
  }
}
