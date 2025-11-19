import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'screens/home_screen.dart';
import 'providers/favorites_provider.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider()..loadFavorites(), 
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