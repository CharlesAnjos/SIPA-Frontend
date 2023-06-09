import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/avaliador.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/avaliadores/form_avaliador.dart';

import 'lista_avaliadores.dart';

Future<Avaliador> fetchAvaliador(id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/avaliador/consultar/$id');
  } else {
    url = Uri.parse('http://localhost:3000/avaliador/consultar/$id');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Avaliador.fromJson(json.decode(response.body)[0]);
  } else {
    throw Exception('Erro ao acessar as avaliadores');
  }
}

void deleteAvaliador(context, id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/avaliador/remover/$id');
  } else {
    url = Uri.parse('http://localhost:3000/avaliador/remover/$id');
  }
  final response = await http.delete(url);
  if (response.statusCode == 200) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ListaAvaliadores()));
  } else {
    throw Exception('Erro ao acessar as avaliadores');
  }
}

class DetalhesAvaliador extends StatelessWidget {
  const DetalhesAvaliador({super.key, required this.avaliador});

  final Avaliador avaliador;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalhes do Avaliador',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ListaAvaliadores())),
              ),
              title: Text(avaliador.pessoa.nome),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FormAvaliador(avaliador: avaliador),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showMyDialog(context);
                    //deleteAvaliador(context, avaliador.id);
                  },
                ),
              ]),
          body: getAvaliador(context)),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagando Avaliador'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Este avaliador será apagada."),
                Text(
                    "ESTA AÇÃO É IRREVERSÍVEL, TODOS OS DADOS SERÃO APAGADOS!"),
                Text(
                    'Para continuar o processo, SEGURE o botão Apagar abaixo.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Apagar'),
              onPressed: () {},
              onLongPress: () {
                deleteAvaliador(context, avaliador.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget getAvaliador(BuildContext context) {
    return FutureBuilder<Avaliador>(
      future: fetchAvaliador(avaliador.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nome: ${snapshot.data!.pessoa.nome}'),
              Text('CPF: ${snapshot.data!.pessoa.cpf}'),
              Text('Registro Avaliador: ${snapshot.data!.registro}'),
              Text('Área de atuação: ${snapshot.data!.area}'),
            ]),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
