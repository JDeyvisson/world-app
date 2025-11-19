// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/country_model.dart';
import '../services/country_service.dart'; // Precisa do serviço
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class DetailScreen extends StatefulWidget {
  final Country country;

  const DetailScreen({Key? key, required this.country}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Country> _detailedCountryFuture;
  final CountryService _countryService = CountryService();

  @override
  void initState() {
    super.initState();
    _detailedCountryFuture =
        _countryService.fetchCountryDetails(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern('pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.namePt), 

        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final bool isFav =
                  favoritesProvider.isFavorite(widget.country.name);
              
              return IconButton(
                icon: Icon(
                  isFav ? Icons.star : Icons.star_border,
                  color: isFav ? Colors.amber : Colors.white,
                ),
                onPressed: () {
                  favoritesProvider.toggleFavorite(widget.country.name);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Country>(
        future: _detailedCountryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Erro ao carregar detalhes:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final country = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Hero(
                tag: country.flagUrl,
                child: Image.network(
                  country.flagUrl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              _buildInfoCard(
                title: 'Informações Principais',
                children: [
                  _buildInfoRow(Icons.location_city, 'Capital', country.capital),
                  _buildInfoRow(Icons.map, 'Região', country.region),
                  _buildInfoRow(Icons.attach_money, 'Moeda', country.currency),
                  _buildInfoRow(Icons.language, 'Língua', country.language),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Geografia e Demografia',
                children: [
                  _buildInfoRow(
                    Icons.people,
                    'População',
                    '${numberFormatter.format(country.population)} habitantes',
                  ),
                  _buildInfoRow(
                    Icons.fullscreen,
                    'Área',
                    '${numberFormatter.format(country.area)} km²',
                  ),
                  _buildInfoRow(
                      Icons.public, 'Sub-região', country.subregion ?? 'N/A'),
                ],
              ),
              const SizedBox(height: 16),
              _buildBordersCard(context, country),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBordersCard(BuildContext context, Country country) {
    final borders = country.borders ?? [];
    if (borders.isEmpty) {
      return _buildInfoCard(
        title: 'Fronteiras',
        children: [
          Text(country.landlocked ?? false
              ? 'Este país não possui fronteiras terrestres (é uma ilha).'
              : 'Nenhuma fronteira terrestre listada.')
        ],
      );
    }

    return _buildInfoCard(
      title: 'Faz Fronteira com (${borders.length})',
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: borders.map((code) {
            return Chip(
              label: Text(code),
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }
}