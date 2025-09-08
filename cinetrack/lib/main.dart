import 'package:cinetrack/core/asset_images.dart';
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
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            // primeira camada de fundo: container com textura granulada
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF191530),
                image: DecorationImage(
                  image: AssetImage(AssetImages.mainBackground),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // camada da frente: container central semi-transparente
            Center(
              child: Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFcd90f5).withAlpha(50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFcd90f5),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AssetImages.mainIcon,
                        width: 75,
                        height: 75,
                      ),
                    ),
                    Text(
                      'CineTrack',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Sua jornada cinematográfica começa aqui',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 400,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFba851a),
                          side: const BorderSide(
                            color: Color(0xFFf5b938),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Altere o valor para o radius desejado
                          ),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Entrar',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 400,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFba851a),
                          side: const BorderSide(
                            color: Color(0xFFf5b938),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Altere o valor para o radius desejado
                          ),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
