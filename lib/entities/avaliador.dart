import './pessoa.dart';

class Avaliador {
  final String id;
  final Pessoa pessoa;
  final String registro;
  final String area;

  const Avaliador({
    required this.id,
    required this.pessoa,
    required this.registro,
    required this.area,
  });

  factory Avaliador.fromJson(Map<String, dynamic> json) {
    return Avaliador(
      id: json['_id'],
      pessoa: Pessoa.fromJson(json['pessoa']),
      registro: json['registro'],
      area: json['area'],
    );
  }

  String toJson() {
    var body =
        '{"id":"$id","pessoa":${pessoa.toJson()},"registro":"$registro","area":"$area"}';
    return body;
  }
}
