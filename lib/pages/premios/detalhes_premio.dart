import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:ntdw_frontend/entities/premio.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/entities/projeto.dart';
import 'package:ntdw_frontend/pages/premios/form_premio.dart';
import 'package:ntdw_frontend/pages/projetos/form_projeto.dart';

import 'lista_premios.dart';

Future<Premio> fetchPremio(id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/premio/consultar/$id');
  } else {
    url = Uri.parse('http://localhost:3000/premio/consultar/$id');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return Premio.fromJson(json.decode(response.body));
  } else {
    throw Exception('Erro ao acessar os prêmios');
  }
}

void deletePremio(context, id) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/premio/remover/$id');
  } else {
    url = Uri.parse('http://localhost:3000/premio/remover/$id');
  }
  final response = await http.delete(url);
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaPremios()));
  } else {
    throw Exception('Erro ao acessar os prêmios');
  }
}

Future<List<Projeto>> fetchProjetosFromPremio(projetoid) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/projeto/listar/$projetoid');
  } else {
    url = Uri.parse('http://10.0.2.2:3000/projeto/listar/$projetoid');
  }
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((projdata) => Projeto.fromJson(projdata)).toList();
  } else {
    throw Exception('Erro ao acessar os projetos');
  }
}

class DetalhesPremio extends StatelessWidget {
  const DetalhesPremio({super.key, required this.premio});

  final Premio premio;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Detalhes do Premio',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaPremios(),
                    ),
                  );
                },
              ),
              title: Text(premio.nome.toString()),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPremio(premio: premio),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showMyDialog(context);
                    //deletePremio(context, premio.id);
                  },
                ),
              ]),
          body: Column(
            children: [
              dadosPremio(context),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormProjeto(premio: premio),
                      ),
                    );
                  },
                  child: const Text("Adicionar Projeto")),
              listaProjetos(context),
            ],
          ),
        ));
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagando Premio'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Este este prêmio será apagado."),
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
                deletePremio(context, premio.id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget dadosPremio(BuildContext context) {
    return FutureBuilder<Premio>(
      future: fetchPremio(premio.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nome do Premio: ${snapshot.data!.nome}'),
              Text('Descrição: ${snapshot.data!.descricao}'),
              Text('Ano: ${snapshot.data!.ano}'),
              Text(
                  'Data: De ${snapshot.data!.dataInicio} a ${snapshot.data!.dataFim}'),
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

  Widget listaProjetos(BuildContext context) {
    return FutureBuilder<List<Projeto>>(
      future: fetchProjetosFromPremio(premio.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              shrinkWrap: true,
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
                            builder: (context) => FormProjeto(
                                premio: snapshot.data![index].premio,
                                projeto: snapshot.data![index]),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 100,
                        child: ListTile(
                          title: Text(snapshot.data![index].titulo),
                          subtitle: Text(snapshot.data![index].resumo),
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
    );
  }
}
