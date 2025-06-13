class Pacientesmodels {
  int? id;
  String nome;
  String celular;
  String email;
  String sexo;
  String dataNasc;
  int altura;
  double peso;
  double peso_alvo;
  double gordura;
  double musculo;
  String nivelAtividade;
  String dataCriacao;

  Pacientesmodels({
    this.id,
    required this.peso_alvo,
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

  final Map<String, double> fatoresAtividade = {
    'Sedentário': 1.2,
    'Leve': 1.375,
    'Moderado': 1.55,
    'Ativo': 1.725,
    'Extremamente ativo': 1.9,
  };

  double get calBasal {
    if (sexo.toLowerCase() == 'masculino') {
      return 88.362 + (13.397 * peso) + (4.799 * altura) - (5.677 * idade);
    } else {
      return 447.593 + (9.247 * peso) + (3.098 * altura) - (4.330 * idade);
    }
  }

  double get calcKcall => calBasal * fatoresAtividade[nivelAtividade]!;

  double get carboidratros => (calcKcall * 0.5) / 4;
  double get proteina => (calcKcall * 0.25) / 4;
  double get lipidios => (calcKcall * 0.25) / 9;

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
      'peso_alvo': peso_alvo,
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
      peso_alvo: map['peso_alvo'],
      gordura: map['gordura'],
      musculo: map['musculo'],
      dataCriacao: map['data_criacao'],
      nivelAtividade: map['nivel_atividade'],
    );
  }

  static Pacientesmodels fromJoinedMap(Map<String, dynamic> map) {
    return Pacientesmodels(
      id: map['paciente_id'],
      nome: map['paciente_nome'],
      celular: map['paciente_celular'],
      email: map['paciente_email'],
      dataNasc: map['paciente_data_nasc'],
      sexo: map['paciente_sexo'],
      altura: map['paciente_altura'],
      peso: map['paciente_peso'],
      peso_alvo: map['paciente_peso_alvo'],
      gordura: map['paciente_gordura'],
      musculo: map['paciente_musculo'],
      dataCriacao: map['paciente_data_criacao'],
      nivelAtividade: map['paciente_nivel_atividade'],
    );
  }

  @override
  String toString() {
    return 'Pacientesmodels(id: $id, nome: $nome, celular: $celular, email: $email, dataNasc: $dataNasc, sexo: $sexo, altura: $altura, peso: $peso, peso_alvo: $peso_alvo, gordura: $gordura, musculo: $musculo, nivelAtividade: $nivelAtividade, dataCriacao: $dataCriacao )';
  }
}
