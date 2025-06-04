class Pacientesmodels {
  int? id;
  String nome;
  String celular;
  String email;
  String sexo;
  String dataNasc;
  int altura;
  double peso;
  double gordura;
  double musculo;
  String nivelAtividade;
  String dataCriacao;

  Pacientesmodels({
    this.id,
    required this.nome,
    required this.celular,
    required this.email,
    required this.dataNasc,
    required this.sexo,
    required this.altura,
    required this.peso,
    required this.gordura,
    required this.musculo,
    required this.dataCriacao,
    required this.nivelAtividade,
  });

  int get idade {
    final nascimento = DateTime.tryParse(dataNasc);
    if (nascimento == null) return 0;
    final hoje = DateTime.now();

    int idadeCalculada = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idadeCalculada--;
    }
    return idadeCalculada;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'celular': celular,
      'email': email,
      'data_nasc': dataNasc,
      'sexo': sexo,
      'altura': altura,
      'peso': peso,
      'gordura': gordura,
      'musculo': musculo,
      'nivel_atividade': nivelAtividade,
      'data_criacao': dataCriacao,
    };
  }

  static Pacientesmodels fromMap(Map<String, dynamic> map) {
    return Pacientesmodels(
      id: map['id'],
      nome: map['nome'],
      celular: map['celular'],
      email: map['email'],
      dataNasc: map['data_nasc'],
      sexo: map['sexo'],
      altura: map['altura'],
      peso: map['peso'],
      gordura: map['gordura'],
      musculo: map['musculo'],
      dataCriacao: map['data_criacao'],
      nivelAtividade: map['nivel_atividade'],
    );
  }

  @override
  String toString() {
    return 'Pacientesmodels(id: $id, nome: $nome, celular: $celular, email: $email, dataNasc: $dataNasc, sexo: $sexo, altura: $altura, peso: $peso, gordura: $gordura, musculo: $musculo, nivelAtividade: $nivelAtividade, dataCriacao: $dataCriacao )';
  }
}
