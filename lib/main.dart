// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar
import 'screens/home_screen.dart';
import 'providers/favorites_provider.dart'; // Importar

void main() {
  // Envolve o app todo no "Gerenciador de Estado"
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider()..loadFavorites(), // Cria o "cérebro" e já carrega os favoritos salvos
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscador de Países',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}