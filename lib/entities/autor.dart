import './pessoa.dart';

class Autor {
  final String id;
  final Pessoa pessoa;
  final String registro;
  final String area;

  const Autor({
    required this.id,
    required this.pessoa,
    required this.registro,
    required this.area,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['_id'],
      pessoa: Pessoa.fromJson(json['pessoa']),
      registro: json['registro'],
      area: json['area'],
    );
  }

  String toJson() {
    var body =
        '{"id":"$id","pessoa":"${pessoa.id}","registro":"$registro","area":"$area"}';
    return body;
  }
}
