import 'package:flutter/material.dart';
import 'package:ntdw_frontend/pages/autores/lista_autores.dart';
import 'package:ntdw_frontend/pages/avaliadores/lista_avaliadores.dart';
import 'package:ntdw_frontend/pages/premios/lista_premios.dart';

void main(List<String> args) {
  const nomes = [
    "Cadastro de Premios",
    "Cadastro de Autores",
    "Cadastro de Avaliadores",
  ];
  const widgets = [ListaPremios(), ListaAutores(), ListaAvaliadores()];
  runApp(MaterialApp(
      title: 'Sistema de Gerenciamento de Premios',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const ListaPremios(),
      // },
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Sistema de Gerenciamento de Premios'),
          ),
          body: Center(
              child: ListView.builder(
                  itemCount: nomes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 75,
                      color: Colors.white,
                      child: Center(
                          child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => widgets[index],
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            child: ListTile(
                              title: Text(nomes[index]),
                            ),
                          ),
                        ),
                      )),
                    );
                  })))));
}
