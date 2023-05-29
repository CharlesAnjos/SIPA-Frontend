import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/premios/lista_premios.dart';

import '../../entities/premio.dart';

void savePremio(context, premio) async {
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
  if (premio.id == "") {
    path = 'premio/novo';
    url = Uri.parse('$server/$path');
    response = await http.post(url, headers: headers, body: premio.toJson());
  } else {
    path = 'premio/atualizar/${premio.id}';
    url = Uri.parse('$server/$path');
    response = await http.patch(url, headers: headers, body: premio.toJson());
  }
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaPremios()));
  } else {
    throw Exception('''\n
      Erro ao salvar o prêmio, erro ${response.statusCode}\n
      Objeto enviado:\n
      ${premio.toJson()}
      Objeto de resposta:\n
      ${response.body}
    ''');
  }
}

class FormPremio extends StatefulWidget {
  const FormPremio({super.key, this.premio});

  final Premio? premio;

  @override
  State<FormPremio> createState() => _FormPremioState();
}

class _FormPremioState extends State<FormPremio> {
  final _formKey = GlobalKey<FormState>();
  var nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final anoController = TextEditingController();
  final dataInicioController = TextEditingController();
  final dataFimController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.premio != null) {
      nomeController.text = widget.premio!.nome;
      descricaoController.text = widget.premio!.descricao;
      anoController.text = widget.premio!.ano;
      dataInicioController.text = widget.premio!.dataInicio;
      dataFimController.text = widget.premio!.dataFim;
    }
    final appTitle =
        widget.premio?.id == null ? 'Novo Prêmio' : 'Editando Prêmio';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(appTitle),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Nome do Projeto',
                    labelText: 'Nome *',
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
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    hintText: 'Descrição do Projeto',
                    labelText: 'Descrição *',
                  ),
                  //initialValue: widget.premio?.id == null ? 'eita' : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Descrição é Obrigatória';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: anoController,
                  decoration: const InputDecoration(
                    hintText: 'Ano de Realização do Projeto',
                    labelText: 'Ano *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ano é Obrigatório';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dataInicioController,
                  decoration: const InputDecoration(
                    hintText: 'Data de Início do Projeto',
                    labelText: 'Data Início *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Data de Início é Obrigatória';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: dataFimController,
                  decoration: const InputDecoration(
                    hintText: 'Data de Fim do Projeto',
                    labelText: 'Data Fim *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Data de Fim é Obrigatória';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Premio premio = Premio(
                            id: widget.premio != null ? widget.premio!.id : "",
                            nome: nomeController.text,
                            descricao: descricaoController.text,
                            ano: anoController.text,
                            dataInicio: dataInicioController.text,
                            dataFim: dataFimController.text);
                        savePremio(context, premio);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
