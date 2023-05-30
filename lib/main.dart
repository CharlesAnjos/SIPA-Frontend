import 'package:flutter/material.dart';
import 'package:ntdw_frontend/pages/premios/lista_premios.dart';

void main(List<String> args) {
  runApp(MaterialApp(
      title: 'Sistema de Gerenciamento de Premios',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    const nomes = [
                      "Cadastro de Premios",
                    ];
                    const widgets = [
                      ListaPremios(),
                    ];
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
