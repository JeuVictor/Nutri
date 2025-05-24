class Pacientesmodels {
  int? id;
  String nome;
  String celular;
  String email;
  String sexo;
  int idade;
  int altura;
  double peso;
  double gordura;
  double musculo;

  Pacientesmodels({
    this.id,
    required this.nome,
    required this.celular,
    required this.email,
    required this.idade,
    required this.sexo,
    required this.altura,
    required this.peso,
    required this.gordura,
    required this.musculo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'celular': celular,
      'email': email,
      'idade': idade,
      'sexo': sexo,
      'altura': altura,
      'peso': peso,
      'gordura': gordura,
      'musculo': musculo,
    };
  }

  static Pacientesmodels fromMap(Map<String, dynamic> map) {
    return Pacientesmodels(
      id: map['id'],
      nome: map['nome'],
      celular: map['celular'],
      email: map['email'],
      idade: map['idade'],
      sexo: map['sexo'],
      altura: map['altura'],
      peso: map['peso'],
      gordura: map['gordura'],
      musculo: map['musculo'],
    );
  }

  @override
  String toString() {
    return 'Pacientesmodels(id: $id, nome: $nome, celular: $celular, email: $email, idade: $idade, sexo: $sexo, altura: $altura, peso: $peso, gordura: $gordura, musculo: $musculo)';
  }
}
