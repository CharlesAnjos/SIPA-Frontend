import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/avaliador.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/avaliadores/form_avaliador.dart';

import 'detalhes_avalidor.dart';

Future<List<Avaliador>> fetchAvaliadores() async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/avaliador/listar');
  } else {
    url = Uri.parse('http://localhost:3000/avaliador/listar');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((avaliador) => Avaliador.fromJson(avaliador))
        .toList();
  } else {
    throw Exception('Erro ao acessar as avaliadores');
  }
}

class ListaAvaliadores extends StatefulWidget {
  const ListaAvaliadores({super.key});

  @override
  State<ListaAvaliadores> createState() => _ListaAvaliadoresState();
}

class _ListaAvaliadoresState extends State<ListaAvaliadores> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lista de Avaliadores',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              title: const Text('Lista de Avaliadores'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FormAvaliador()),
                    );
                  },
                ),
              ]),
          body: Center(
            child: FutureBuilder<List<Avaliador>>(
              future: fetchAvaliadores(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 75,
                          color: Colors.white,
                          child: Center(
                              //child: Text(snapshot.data![index].nome),
                              child: Card(
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetalhesAvaliador(
                                        avaliador: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 100,
                                child: ListTile(
                                  title:
                                      Text(snapshot.data![index].pessoa.nome),
                                  subtitle: Text(snapshot.data![index].area),
                                ),
                              ),
                            ),
                          )),
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ));
  }
}
