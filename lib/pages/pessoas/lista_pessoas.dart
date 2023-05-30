import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/pessoa.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/pessoas/form_pessoa.dart';

import 'detalhes_pessoa.dart';

Future<List<Pessoa>> fetchPessoas() async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/pessoa/listar');
  } else {
    url = Uri.parse('http://localhost:3000/pessoa/listar');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((pessoa) => Pessoa.fromJson(pessoa)).toList();
  } else {
    throw Exception('Erro ao acessar as pessoas');
  }
}

class ListaPessoas extends StatefulWidget {
  const ListaPessoas({super.key});

  @override
  State<ListaPessoas> createState() => _ListaPessoasState();
}

class _ListaPessoasState extends State<ListaPessoas> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lista de Pessoas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text('Lista de Pessoas'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FormPessoa()),
                    );
                  },
                ),
              ]),
          body: Center(
            child: FutureBuilder<List<Pessoa>>(
              future: fetchPessoas(),
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
                                    builder: (context) => DetalhesPessoa(
                                        pessoa: snapshot.data![index]),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 100,
                                child: ListTile(
                                  title: Text(snapshot.data![index].nome),
                                  subtitle: Text(snapshot.data![index].cpf),
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
