import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/autores/lista_autores.dart';

import '../../entities/autor.dart';
import '../../entities/pessoa.dart';

void saveAutor(context, autor) async {
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
  if (autor.id == "") {
    path = 'autor/novo';
    url = Uri.parse('$server/$path');
    response = await http.post(url, headers: headers, body: autor.toJson());
  } else {
    path = 'autor/atualizar/${autor.id}';
    url = Uri.parse('$server/$path');
    response = await http.patch(url, headers: headers, body: autor.toJson());
  }
  if (response.statusCode == 200) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ListaAutores()));
  } else {
    throw Exception('''\n
      Erro ao salvar o prêmio, erro ${response.statusCode}\n
      Objeto enviado:\n
      ${autor.toJson()}
      Objeto de resposta:\n
      ${response.body}
    ''');
  }
}

class FormAutor extends StatefulWidget {
  const FormAutor({super.key, this.autor});

  final Autor? autor;

  @override
  State<FormAutor> createState() => _FormAutorState();
}

class _FormAutorState extends State<FormAutor> {
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
    if (widget.autor != null) {
      nomeController.text = widget.autor!.pessoa.nome;
      cpfController.text = widget.autor!.pessoa.cpf;
      emailController.text = widget.autor!.pessoa.email;
      registroController.text = widget.autor!.registro;
      areaController.text = widget.autor!.area;
    }
    final appTitle = widget.autor?.id == null ? 'Nova Autor' : 'Editando Autor';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ListaAutores())),
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
                    hintText: 'Nome do Autor',
                    labelText: 'Nome do Autor *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome do Autor é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: cpfController,
                  decoration: const InputDecoration(
                    hintText: 'CPF do Autor',
                    labelText: 'CPF do Autor *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CPF do Autor é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Endereço de email do Autor',
                    labelText: 'email do Autor *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email do Autor é Obrigatório';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  controller: registroController,
                  decoration: const InputDecoration(
                    hintText: 'Registro do Autor',
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
                    hintText: 'Área de Atuação do Autor',
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
                            id: widget.autor != null
                                ? widget.autor!.pessoa.id
                                : "",
                            nome: nomeController.text,
                            cpf: cpfController.text,
                            email: emailController.text);
                        Autor autor = Autor(
                          id: widget.autor != null ? widget.autor!.id : "",
                          pessoa: pessoa,
                          registro: registroController.text,
                          area: areaController.text,
                        );
                        saveAutor(context, autor);
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
