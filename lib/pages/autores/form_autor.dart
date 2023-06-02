import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntdw_frontend/pages/autores/lista_autores.dart';

import '../../entities/autor.dart';

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
  final pessoaIdController = TextEditingController();
  final registroController = TextEditingController();
  final areaController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    pessoaIdController.dispose();
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
      //pessoaIdController.text = widget.autor!.pessoaid;
      registroController.text = widget.autor!.registro;
      areaController.text = widget.autor!.area;
    }
    final appTitle = widget.autor?.id == null ? 'Nova Autor' : 'Editando Autor';

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
                  controller: pessoaIdController,
                  decoration: const InputDecoration(
                    hintText: 'ID de Pessoa do Autor',
                    labelText: 'ID de Pessoa *',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID de Pessoa é Obrigatório';
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
                  //initialValue: widget.autor?.id == null ? 'eita' : null,
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
                        // Autor autor = Autor(
                        //   id: widget.autor != null ? widget.autor!.id : "",
                        //   //pessoaid: pessoaIdController.text,
                        //   registro: registroController.text,
                        //   area: areaController.text,
                        // );
                        // saveAutor(context, autor);
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
