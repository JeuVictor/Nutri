class UsuarioModel {
  final int? id;
  final String nome;
  final String crn;
  final String telefone;
  final String? email;
  final String? esp; //especialidade
  final String? endereco;
  final String? caminhoImg;
  final String? corTema;

  UsuarioModel({
    this.id,
    this.email,
    this.esp,
    this.endereco,
    this.caminhoImg,
    this.corTema,
    required this.nome,
    required this.crn,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'crn': crn,
      'telefone': telefone,
      'email': email,
      'esp': esp,
      'endereco': endereco,
      'caminhoImg': caminhoImg,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      nome: map['nome'],
      crn: map['crn'],
      telefone: map['telefone'],
      email: map['email'],
      esp: map['esp'],
      caminhoImg: map['caminhoImg'],
      corTema: map['corTema'],
      endereco: map['endereco'],
      id: map['id'],
    );
  }
}
