import 'package:flutter/material.dart';
import 'package:ntdw_frontend/pages/premios/lista_premios.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'Sistema de Gerenciamento de Premios',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const ListaPremios(),
    },
  ));
}
