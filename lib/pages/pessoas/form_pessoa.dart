import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/pessoas/lista_pessoas.dart';

import '../../entities/pessoa.dart';

void savePessoa(context, pessoa) async {
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
  if (pessoa.id == "") {
    path = 'pessoa/novo';
    url = Uri.parse('$server/$path');
    response = await http.post(url, headers: headers, body: pessoa.toJson());
  } else {
    path = 'pessoa/atualizar/${pessoa.id}';
    url = Uri.parse('$server/$path');
    response = await http.patch(url, headers: headers, body: pessoa.toJson());
  }
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaPessoas()));
  } else {
    throw Exception('''\n
      Erro ao salvar o prêmio, erro ${response.statusCode}\n
      Objeto enviado:\n
      ${pessoa.toJson()}
      Objeto de resposta:\n
      ${response.body}
    ''');
  }
}

class FormPessoa extends StatefulWidget {
  const FormPessoa({super.key, this.pessoa});

  final Pessoa? pessoa;

  @override
  State<FormPessoa> createState() => _FormPessoaState();
}

class _FormPessoaState extends State<FormPessoa> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pessoa != null) {
      nomeController.text = widget.pessoa!.nome;
      cpfController.text = widget.pessoa!.cpf;
      emailController.text = widget.pessoa!.email;
    }
    final appTitle =
        widget.pessoa?.id == null ? 'Nova Pessoa' : 'Editando Pessoa';

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
                    hintText: 'Nome da Pessoa',
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
                  controller: cpfController,
                  decoration: const InputDecoration(
                    hintText: 'CPF da Pessoa',
                    labelText: 'CPF *',
                  ),
                  //initialValue: widget.pessoa?.id == null ? 'eita' : null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CPF é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'eMail da Pessoa',
                    labelText: 'eMail *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'eMail é Obrigatório';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Pessoa pessoa = Pessoa(
                          id: widget.pessoa != null ? widget.pessoa!.id : "",
                          nome: nomeController.text,
                          cpf: cpfController.text,
                          email: emailController.text,
                        );
                        savePessoa(context, pessoa);
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
