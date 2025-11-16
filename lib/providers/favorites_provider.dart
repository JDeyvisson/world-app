// lib/providers/favorites_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// O "Cérebro" que gerencia os favoritos
class FavoritesProvider with ChangeNotifier {
  
  // Chave para salvar no armazenamento
  static const String _favoritesKey = 'favoriteCountries';

  // O estado em memória. Usamos um Set para performance
  // e para não permitir nomes duplicados.
  Set<String> _favoriteCountryNames = {};

  // Construtor "público" para que outros widgets possam ler a lista
  // Usamos 'unmodifiable' para que ninguém possa alterar a lista
  // sem usar os nossos métodos (toggleFavorite).
  Set<String> get favoriteCountryNames =>
      Set.unmodifiable(_favoriteCountryNames);

  // Método para verificar se um país é favorito
  bool isFavorite(String countryName) {
    return _favoriteCountryNames.contains(countryName);
  }

  // O método principal: Adiciona ou remove um favorito
  Future<void> toggleFavorite(String countryName) async {
    if (isFavorite(countryName)) {
      _favoriteCountryNames.remove(countryName);
    } else {
      _favoriteCountryNames.add(countryName);
    }
    
    // Salva a alteração no disco
    await _saveFavorites();
    // Avisa todos os widgets que estão "ouvindo" que o estado mudou
    notifyListeners();
  }

  // --- Métodos de Salvar e Carregar ---

  // Carrega a lista salva no disco (SharedPreferences)
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Pega a lista de strings salva no disco
    final savedList = prefs.getStringList(_favoritesKey);
    
    if (savedList != null) {
      _favoriteCountryNames = Set.from(savedList);
    }
    
    // Avisa os widgets após o carregamento inicial
    notifyListeners();
  }

  // Salva a lista atual no disco
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Converte o Set para uma List<String> para poder salvar
    await prefs.setStringList(_favoritesKey, _favoriteCountryNames.toList());
  }
}