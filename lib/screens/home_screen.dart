import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart';
import 'detail_screen.dart';
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

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        
        final nameLower = country.name.toLowerCase();     
        final namePtLower = country.namePt.toLowerCase(); 
        final capitalLower = country.capital.toLowerCase();
        final currencyLower = country.currency.toLowerCase();
        final languageLower = country.language.toLowerCase();
        final regionLower = country.region.toLowerCase();

        return nameLower.contains(query) ||  
            namePtLower.contains(query) || 
            capitalLower.contains(query) ||
            currencyLower.contains(query) ||
            languageLower.contains(query) ||
            regionLower.contains(query);
      }).toList();
    });
  }

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

        displayList.sort((a, b) {
          final bool isAFav = favoritesProvider.isFavorite(a.name);
          final bool isBFav = favoritesProvider.isFavorite(b.name);

          if (isAFav && !isBFav) return -1;
          if (!isAFav && isBFav) return 1;

          return a.namePt.compareTo(b.namePt); 
        });

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