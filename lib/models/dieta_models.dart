class DietaModels {
  final int? id;
  final String nome;
  final String dataCriacao;
  final int pacienteId;

  DietaModels({
    this.id,
    required this.nome,
    required this.dataCriacao,
    required this.pacienteId,
  });

  factory DietaModels.fromMap(Map<String, dynamic> map) {
    return DietaModels(
      id: map['id'],
      nome: map['nome'],
      dataCriacao: map['data_criacao'],
      pacienteId: map['paciente_id'],
    );
  }
  DietaModels copyWith({
    int? id,
    String? nome,
    String? dataCriacao,
    int? pacienteId,
  }) {
    return DietaModels(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      pacienteId: pacienteId ?? this.pacienteId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'data_criacao': dataCriacao,
      'paciente_id': pacienteId,
    };
  }


  
}
