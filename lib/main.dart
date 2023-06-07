import 'package:flutter/material.dart';
import 'package:cadastramento_pontos_turisticos/pages/filtroPage.dart';
import 'package:cadastramento_pontos_turisticos/pages/listaPontosTuristicos.dart';

void main() {
  runApp(const AppPontosTuristicos());
}

class AppPontosTuristicos extends StatelessWidget {
  const AppPontosTuristicos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pontos Turísticos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.orange,
      ),
      home: ListaPontosTuristicosPage(),
      routes: {
        FiltroPage.routeName: (BuildContext context) => FiltroPage(),
      },
    );
  }
}
