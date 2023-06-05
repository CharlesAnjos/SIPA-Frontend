import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/pessoa.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/pessoas/form_pessoa.dart';

import 'lista_pessoas.dart';

Future<Pessoa> fetchPessoa(id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/pessoa/consultar/$id');
  } else {
    url = Uri.parse('http://localhost:3000/pessoa/consultar/$id');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print(json.decode(response.body).runtimeType);
    return Pessoa.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao acessar as pessoas');
  }
}

void deletePessoa(context, id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/pessoa/remover/$id');
  } else {
    url = Uri.parse('http://localhost:3000/pessoa/remover/$id');
  }
  final response = await http.delete(url);
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaPessoas()));
  } else {
    throw Exception('Erro ao acessar as pessoas');
  }
}

class DetalhesPessoa extends StatelessWidget {
  const DetalhesPessoa({super.key, required this.pessoa});

  final Pessoa pessoa;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalhes do Pessoa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(pessoa.nome.toString()),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPessoa(pessoa: pessoa),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showMyDialog(context);
                    //deletePessoa(context, pessoa.id);
                  },
                ),
              ]),
          body: listaPessoas(context)),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagando Pessoa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Este pessoa será apagada."),
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
                deletePessoa(context, pessoa.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget listaPessoas(BuildContext context) {
    return FutureBuilder<Pessoa>(
      future: fetchPessoa(pessoa.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nome do Pessoa: ${snapshot.data!.nome}'),
              Text('CPF: ${snapshot.data!.cpf}'),
              Text('eMail: ${snapshot.data!.email}'),
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
