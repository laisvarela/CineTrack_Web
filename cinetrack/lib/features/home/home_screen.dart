import 'package:cinetrack/theme/web_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('CineTrack'),
        actions: [
          Row(
            
          )
        ],
      ),
    );
  }
}