import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
// cor azul de fundo #191530
// roxo #361d57
// botão não selecionado #333a4d
// botão selecionado #ba851a
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineTrack'),
      ),
    );
  }
}
