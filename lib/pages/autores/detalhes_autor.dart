import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/autor.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/autores/form_autor.dart';

import 'lista_autores.dart';

Future<Autor> fetchAutor(id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/autor/consultar/$id');
  } else {
    url = Uri.parse('http://localhost:3000/autor/consultar/$id');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Autor.fromJson(json.decode(response.body)[0]);
  } else {
    throw Exception('Erro ao acessar as autores');
  }
}

void deleteAutor(context, id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/autor/remover/$id');
  } else {
    url = Uri.parse('http://localhost:3000/autor/remover/$id');
  }
  final response = await http.delete(url);
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaAutores()));
  } else {
    throw Exception('Erro ao acessar as autores');
  }
}

class DetalhesAutor extends StatelessWidget {
  const DetalhesAutor({super.key, required this.autor});

  final Autor autor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalhes do Autor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(autor.pessoa.nome),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormAutor(autor: autor),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showMyDialog(context);
                    //deleteAutor(context, autor.id);
                  },
                ),
              ]),
          body: getAutor(context)),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagando Autor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Este autor será apagada."),
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
                deleteAutor(context, autor.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget getAutor(BuildContext context) {
    return FutureBuilder<Autor>(
      future: fetchAutor(autor.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('ID Pessoa: ${snapshot.data!.pessoa.id}'),
              Text('Registro Autor: ${snapshot.data!.registro}'),
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
