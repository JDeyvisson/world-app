// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart';
import 'detail_screen.dart'; // 1. IMPORTAR A NOVA TELA
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();
  final CountryService _countryService = CountryService();

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    try {
      final countries = await _countryService.fetchCountries();
      
      // MUDANÇA AQUI: Ordenar por 'namePt' (Português) em vez de 'name'
      countries.sort((a, b) => a.namePt.compareTo(b.namePt));
      
      setState(() {
        _allCountries = countries;
        _filteredCountries = countries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

 // lib/screens/home_screen.dart

// ... (todo o código antes da função)

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        
        // --- ADICIONANDO AS DUAS VARIÁVEIS DE NOME ---
        final nameLower = country.name.toLowerCase();     // Nome em inglês
        final namePtLower = country.namePt.toLowerCase(); // Nome em português
        
        // Mantém os outros campos de busca
        final capitalLower = country.capital.toLowerCase();
        final currencyLower = country.currency.toLowerCase();
        final languageLower = country.language.toLowerCase();
        final regionLower = country.region.toLowerCase();

        // --- LÓGICA DE BUSCA ATUALIZADA ---
        // Agora verifica o nome em inglês E o nome em português
        return nameLower.contains(query) ||     // LINHA READICIONADA
            namePtLower.contains(query) || 
            capitalLower.contains(query) ||
            currencyLower.contains(query) ||
            languageLower.contains(query) ||
            regionLower.contains(query);
      }).toList();
    });
  }

// ... (o resto do código do home_screen.dart)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Países'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar (Nome, Moeda, Língua, Região...)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          'Erro ao carregar países:\n$_errorMessage',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }
    if (_filteredCountries.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'Nenhum país encontrado.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        
        final List<Country> displayList = List.from(_filteredCountries);

        // --- LÓGICA DE ORDENAÇÃO CORRIGIDA ---
        displayList.sort((a, b) {
          final bool isAFav = favoritesProvider.isFavorite(a.name);
          final bool isBFav = favoritesProvider.isFavorite(b.name);

          // Regra 1: Favoritos vêm antes de não-favoritos.
          if (isAFav && !isBFav) return -1;
          if (!isAFav && isBFav) return 1;

          // Regra 2: (O DESEMPATE)
          // Se ambos são favoritos, ou ambos são não-favoritos,
          // usa a ordem alfabética por nome em português.
          return a.namePt.compareTo(b.namePt); // <-- A CORREÇÃO ESTÁ AQUI
        });

        // O resto da função é igual...
        return ListView.builder(
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            final country = displayList[index];
            final bool isFav = favoritesProvider.isFavorite(country.name);

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(country: country),
                  ),
                );
              },
              child: Hero(
                tag: country.flagUrl,
                child: CountryCard(
                  country: country,
                  isFavorite: isFav,
                  onToggleFavorite: () {
                    favoritesProvider.toggleFavorite(country.name);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}