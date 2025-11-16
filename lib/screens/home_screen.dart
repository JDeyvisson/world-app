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
      // Ordena a lista alfabeticamente
      countries.sort((a, b) => a.name.compareTo(b.name));
      
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

    // --- MUDANÇA PRINCIPAL AQUI ---
    // Usamos um "Consumer" para "ouvir" o provider de favoritos
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        
        // O ListView agora é construído DENTRO do Consumer
        return ListView.builder(
          itemCount: _filteredCountries.length,
          itemBuilder: (context, index) {
            final country = _filteredCountries[index];
            
            // Pergunta ao provider se este país é favorito
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
                // Passa o status de favorito e a função de clique
                // para o CountryCard
                child: CountryCard(
                  country: country,
                  isFavorite: isFav,
                  onToggleFavorite: () {
                    // Chama a função de toggle do provider
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