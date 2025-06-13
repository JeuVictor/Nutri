class DietaModels {
  final int? id;
  final String nome;
  final String dataCriacao;
  final int pacienteId;
  final String obs;
  final String frequencia;

  DietaModels({
    this.id,
    required this.nome,
    required this.dataCriacao,
    required this.pacienteId,
    required this.frequencia,
    required this.obs,
  });

  factory DietaModels.fromMap(Map<String, dynamic> map) {
    return DietaModels(
      id: map['id'],
      nome: map['nome'],
      dataCriacao: map['data_criacao'],
      pacienteId: map['paciente_id'],
      frequencia: map['frequencia'],
      obs: map['obs'],
    );
  }
  factory DietaModels.fromJoinMap(Map<String, dynamic> map) {
  return DietaModels(
    id: map['dieta_id'],
    nome: map['dieta_nome'],
    dataCriacao: map['data_criacao'],
    pacienteId: map['paciente_id'],
    frequencia: map['frequencia'],
    obs: map['obs'],
  );
}

  DietaModels copyWith({
    int? id,
    String? nome,
    String? dataCriacao,
    int? pacienteId,
    String? obs,
    String? frequencia,
  }) {
    return DietaModels(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      pacienteId: pacienteId ?? this.pacienteId,
      frequencia: frequencia ?? this.frequencia,
      obs: obs ?? this.obs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_criacao': dataCriacao,
      'paciente_id': pacienteId,
      'frequencia': frequencia,
      'obs': obs,
    };
  }
}
