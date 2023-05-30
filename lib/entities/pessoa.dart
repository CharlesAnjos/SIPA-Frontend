class Pessoa {
  final String id;
  final String nome;
  final String cpf;
  final String email;

  const Pessoa({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      id: json['_id'],
      nome: json['nome'],
      cpf: json['cpf'],
      email: json['email'],
    );
  }

  String toJson() {
    var body = '{"id":"$id","nome":"$nome","cpf":"$cpf","email":"$email"}';
    return body;
  }
}
