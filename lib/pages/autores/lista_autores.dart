import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/autor.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/autores/form_autor.dart';

import 'detalhes_autor.dart';

Future<List<Autor>> fetchAutores() async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/autor/listar');
  } else {
    url = Uri.parse('http://localhost:3000/autor/listar');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((autor) => Autor.fromJson(autor)).toList();
  } else {
    throw Exception('Erro ao acessar as autores');
  }
}

class ListaAutores extends StatefulWidget {
  const ListaAutores({super.key});

  @override
  State<ListaAutores> createState() => _ListaAutoresState();
}

class _ListaAutoresState extends State<ListaAutores> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lista de Autores',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              title: const Text('Lista de Autores'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FormAutor()),
                    );
                  },
                ),
              ]),
          body: Center(
            child: FutureBuilder<List<Autor>>(
              future: fetchAutores(),
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
                                    builder: (context) => DetalhesAutor(
                                        autor: snapshot.data![index]),
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
