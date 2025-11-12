// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart';
import '../widgets/country_card.dart'; // Importa nosso widget customizado

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- ESTADO (State) ---
  bool _isLoading = true;
  String _errorMessage = ''; // Para guardar mensagens de erro
  List<Country> _allCountries = []; // Lista completa de países da API
  List<Country> _filteredCountries = []; // Lista filtrada pela busca
  final TextEditingController _searchController = TextEditingController();

  // Instância do nosso serviço de API
  final CountryService _countryService = CountryService();

  // --- LÓGICA DE NEGÓCIO ---

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

  // Função para buscar os dados da API usando o Serviço
  Future<void> _fetchCountries() async {
    try {
      final countries = await _countryService.fetchCountries();

      countries.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        _allCountries = countries;
        _filteredCountries = countries;
        _isLoading = false;
      });
    } catch (e) {
      // Captura o erro do serviço
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Função para filtrar a lista de países
  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((country) {
        // Verifica se o termo de busca está contido em qualquer um dos campos
        final nameLower = country.name.toLowerCase();
        final capitalLower = country.capital.toLowerCase();
        final currencyLower = country.currency.toLowerCase();
        final languageLower = country.language.toLowerCase();
        final regionLower = country.region.toLowerCase();

        return nameLower.contains(query) ||
            capitalLower.contains(query) ||
            currencyLower.contains(query) ||
            languageLower.contains(query) ||
            regionLower.contains(query);
      }).toList();
    });
  }

  // --- CONSTRUÇÃO DA UI (View) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Países'),
      ),
      body: Column(
        children: [
          // --- CAMPO DE BUSCA ---
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

          // --- LISTA DE PAÍSES ---
          Expanded(
            child: _buildBody(), // Chama um método auxiliar para o corpo
          ),
        ],
      ),
    );
  }

  // Método auxiliar para construir o corpo principal (Loading, Erro, Lista)
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

    return ListView.builder(
      itemCount: _filteredCountries.length,
      itemBuilder: (context, index) {
        final country = _filteredCountries[index];
        // Usa o widget customizado!
        return CountryCard(country: country);
      },
    );
  }
}