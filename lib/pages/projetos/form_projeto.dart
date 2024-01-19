import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/premios/detalhes_premio.dart';
import '../../entities/premio.dart';

import '../../entities/projeto.dart';
import '../../entities/autor.dart';

void saveProjeto(context, Projeto projeto, Premio premio) async {
  String server = "";
  String path = "";
  Uri url;
  http.Response response;
  Map<String, String>? headers = {
    'Content-Type': 'application/json; charset=UTF-8'
  };
  if (Platform.isAndroid) {
    server = 'http://10.0.2.2:3000';
  } else {
    server = 'http://localhost:3000';
  }
  if (projeto.id == "") {
    path = 'projeto/novo';
    url = Uri.parse('$server/$path');
    response = await http.post(url, headers: headers, body: projeto.toJson());
  } else {
    path = 'projeto/atualizar/${projeto.id}';
    url = Uri.parse('$server/$path');
    response = await http.patch(url, headers: headers, body: projeto.toJson());
  }
  if (response.statusCode == 200) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetalhesPremio(premio: premio)));
  } else {
    throw Exception('''\n
      Erro ao salvar o projeto, erro ${response.statusCode}\n
      Objeto enviado:\n
      ${projeto.toJson()}
      Objeto de resposta:\n
      ${response.body}
    ''');
  }
}

void deleteProjeto(context, id, premio) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:3000/projeto/remover/$id');
  } else {
    url = Uri.parse('http://localhost:3000/projeto/remover/$id');
  }
  final response = await http.delete(url);
  if (response.statusCode == 200) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DetalhesPremio(premio: premio)));
  } else {
    throw Exception('Erro ao acessar os prêmios');
  }
}

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

class FormProjeto extends StatefulWidget {
  const FormProjeto(
      {super.key, this.projeto, required this.premio, this.autores});

  final Projeto? projeto;
  final Premio premio;
  final List<Autor>? autores;

  @override
  State<FormProjeto> createState() => _FormProjetoState();
}

class _FormProjetoState extends State<FormProjeto> {
  final _formKey = GlobalKey<FormState>();
  var tituloController = TextEditingController();
  final resumoController = TextEditingController();
  final dataEnvioController = TextEditingController();
  var selectedAutoresId = <String>[];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    tituloController.dispose();
    resumoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.projeto != null) {
      tituloController.text = widget.projeto!.titulo;
      resumoController.text = widget.projeto!.resumo;
      dataEnvioController.text = widget.projeto!.dataEnvio;
    }
    final appTitle = widget.projeto?.id == null
        ? 'Novo Projeto'
        : 'Editando ${widget.projeto?.titulo}';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesPremio(premio: widget.premio),
                  ),
                );
              },
            ),
            title: Text(appTitle),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showMyDialog(context);
                  //deletePremio(context, premio.id);
                },
              )
            ]),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Prêmio',
                    labelText: 'Prêmio',
                  ),
                  initialValue: widget.premio.nome,
                  enabled: false,
                ),
                const Text(
                  "Selecione os autores",
                  style: TextStyle(color: Colors.grey),
                ),
                autorDropDown(widget, context),
                TextFormField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    hintText: 'Título do Projeto',
                    labelText: 'Título *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: resumoController,
                  decoration: const InputDecoration(
                    hintText: 'Resumo do Projeto',
                    labelText: 'Resumo *',
                  ),
                  //initialValue: widget.projeto?.id == null ? 'eita' : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descrição é Obrigatória';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Projeto projeto = Projeto(
                            id: widget.projeto != null
                                ? widget.projeto!.id
                                : "",
                            premio: widget.premio,
                            autores: selectedAutoresId,
                            titulo: tituloController.text,
                            resumo: resumoController.text,
                            dataEnvio: DateTime.now().toString());
                        saveProjeto(context, projeto, widget.premio);
                      }
                    },
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apagando Projeto'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Este este projeto será apagado."),
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
                deleteProjeto(context, widget.projeto!.id, widget.premio);
              },
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<List<Autor>> autorDropDown(widget, context) {
    if (widget.projeto != null && widget.projeto.autores != null) {
      if (widget.projeto.autores.runtimeType == List<Autor>) {
        widget.projeto!.autores.forEach((autor) {
          selectedAutoresId.add(autor.id);
        });
      } else {
        widget.projeto!.autores.forEach((autor) {
          selectedAutoresId.add(autor);
        });
      }
    }
    return FutureBuilder<List<Autor>>(
      future: fetchAutores(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var isChecked =
                    selectedAutoresId.contains(snapshot.data![index].id);
                return Container(
                  height: 75,
                  color: Colors.white,
                  child: Center(
                    child: ListTile(
                      title: Text(snapshot.data![index].pessoa.nome),
                      trailing: Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedAutoresId.add(snapshot.data![index].id);
                            } else {
                              selectedAutoresId
                                  .remove(snapshot.data![index].id);
                            }
                          });
                        },
                      ),
                    ),
                  ),
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
