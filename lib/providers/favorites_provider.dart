import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  
  static const String _favoritesKey = 'favoriteCountries';

  Set<String> _favoriteCountryNames = {};

  Set<String> get favoriteCountryNames =>
      Set.unmodifiable(_favoriteCountryNames);

  bool isFavorite(String countryName) {
    return _favoriteCountryNames.contains(countryName);
  }

  Future<void> toggleFavorite(String countryName) async {
    if (isFavorite(countryName)) {
      _favoriteCountryNames.remove(countryName);
    } else {
      _favoriteCountryNames.add(countryName);
    }

    await _saveFavorites();

    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_favoritesKey);
    
    if (savedList != null) {
      _favoriteCountryNames = Set.from(savedList);
    }

    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteCountryNames.toList());
  }
}