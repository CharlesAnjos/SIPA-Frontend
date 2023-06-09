import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/avaliadores/lista_avaliadores.dart';

import '../../entities/avaliador.dart';
import '../../entities/pessoa.dart';

void saveAvaliador(context, avaliador) async {
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
  if (avaliador.id == "") {
    path = 'avaliador/novo';
    url = Uri.parse('$server/$path');
    response = await http.post(url, headers: headers, body: avaliador.toJson());
  } else {
    path = 'avaliador/atualizar/${avaliador.id}';
    url = Uri.parse('$server/$path');
    response =
        await http.patch(url, headers: headers, body: avaliador.toJson());
  }
  if (response.statusCode == 200) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ListaAvaliadores()));
  } else {
    throw Exception('''\n
      Erro ao salvar o prêmio, erro ${response.statusCode}\n
      Objeto enviado:\n
      ${avaliador.toJson()}
      Objeto de resposta:\n
      ${response.body}
    ''');
  }
}

class FormAvaliador extends StatefulWidget {
  const FormAvaliador({super.key, this.avaliador});

  final Avaliador? avaliador;

  @override
  State<FormAvaliador> createState() => _FormAvaliadorState();
}

class _FormAvaliadorState extends State<FormAvaliador> {
  final _formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final registroController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    registroController.dispose();
    areaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.avaliador != null) {
      nomeController.text = widget.avaliador!.pessoa.nome;
      cpfController.text = widget.avaliador!.pessoa.cpf;
      emailController.text = widget.avaliador!.pessoa.email;
      registroController.text = widget.avaliador!.registro;
      areaController.text = widget.avaliador!.area;
    }
    final appTitle =
        widget.avaliador?.id == null ? 'Nova Avaliador' : 'Editando Avaliador';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListaAvaliadores())),
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
                    hintText: 'Nome do Avaliador',
                    labelText: 'Nome do Avaliador *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome do Avaliador é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: cpfController,
                  decoration: const InputDecoration(
                    hintText: 'CPF do Avaliador',
                    labelText: 'CPF do Avaliador *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CPF do Avaliador é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Endereço de email do Avaliador',
                    labelText: 'email do Avaliador *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email do Avaliador é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: registroController,
                  decoration: const InputDecoration(
                    hintText: 'Registro do Avaliador',
                    labelText: 'Registro *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Registro é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    hintText: 'Área de Atuação do Avaliador',
                    labelText: 'Área de Atuação *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Área de Atuação é Obrigatória';
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
                            id: widget.avaliador != null
                                ? widget.avaliador!.pessoa.id
                                : "",
                            nome: nomeController.text,
                            cpf: cpfController.text,
                            email: emailController.text);
                        Avaliador avaliador = Avaliador(
                          id: widget.avaliador != null
                              ? widget.avaliador!.id
                              : "",
                          pessoa: pessoa,
                          registro: registroController.text,
                          area: areaController.text,
                        );
                        saveAvaliador(context, avaliador);
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
