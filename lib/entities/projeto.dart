import 'dart:convert';

import 'premio.dart';

class Projeto {
  final String id;
  final Premio premio;
  final List<String> autores;
  final String titulo;
  final String resumo;
  final String dataEnvio;

  const Projeto({
    required this.id,
    required this.premio,
    required this.autores,
    required this.titulo,
    required this.resumo,
    required this.dataEnvio,
  });

  factory Projeto.fromJson(Map<String, dynamic> jsonprojeto) {
    return Projeto(
      id: jsonprojeto['_id'],
      premio: Premio.fromJson(jsonprojeto['premio']),
      autores: List<String>.from(jsonprojeto['autores']),
      titulo: jsonprojeto['titulo'].toString(),
      resumo: jsonprojeto['resumo'].toString(),
      dataEnvio: jsonprojeto['dataEnvo'].toString(),
    );
  }

  String toJson() {
    var body = '''{
      "id":"$id",
      "premio":"${premio.id}",
      "autores":${jsonEncode(autores)},
      "titulo":"$titulo",
      "resumo":"$resumo",
      "dataEnvio":"$dataEnvio"
      }
    ''';
    return body;
  }
}
