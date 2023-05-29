import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/premio.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/premios/form_premio.dart';

import 'detalhes_premio.dart';

Future<List<Premio>> fetchPremios() async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/premio/listar');
  } else {
    url = Uri.parse('http://localhost:3000/premio/listar');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((premio) => Premio.fromJson(premio)).toList();
  } else {
    throw Exception('Erro ao acessar os prêmios');
  }
}

class ListaPremios extends StatefulWidget {
  const ListaPremios({super.key});

  @override
  State<ListaPremios> createState() => _ListaPremiosState();
}

class _ListaPremiosState extends State<ListaPremios> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lista de Premios',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar:
              AppBar(title: const Text('Lista de Premios'), actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FormPremio()),
                );
              },
            ),
          ]),
          body: Center(
            child: FutureBuilder<List<Premio>>(
              future: fetchPremios(),
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
                                    builder: (context) => DetalhesPremio(
                                        premio: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 100,
                                child: ListTile(
                                  title: Text(snapshot.data![index].nome),
                                  subtitle:
                                      Text(snapshot.data![index].descricao),
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
