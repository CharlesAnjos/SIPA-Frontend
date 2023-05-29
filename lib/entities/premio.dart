class Premio {
  final String id;
  final String nome;
  final String descricao;
  final String ano;
  final String dataInicio;
  final String dataFim;

  const Premio(
      {required this.id,
      required this.nome,
      required this.descricao,
      required this.ano,
      required this.dataInicio,
      required this.dataFim});

  factory Premio.fromJson(Map<String, dynamic> json) {
    return Premio(
      id: json['_id'],
      nome: json['nome'],
      descricao: json['descricao'],
      ano: json['ano'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
    );
  }

  String toJson() {
    var body =
        '{"id":"$id","nome":"$nome","descricao":"$descricao","ano":"$ano","dataInicio":"$dataInicio","dataFim":"$dataFim"}';
    return body;
  }
}
