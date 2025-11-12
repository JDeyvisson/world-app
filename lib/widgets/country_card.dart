// lib/widgets/country_card.dart

import 'package:flutter/material.dart';
import '../models/country_model.dart'; // Importa o modelo

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        // --- BANDEIRA ---
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            country.flagUrl,
            width: 60,
            fit: BoxFit.cover,
            // Fallback em caso de erro ao carregar a imagem
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 40,
              color: Colors.grey[200],
              child: Icon(Icons.flag, color: Colors.grey[600]),
            ),
          ),
        ),
        // --- NOME ---
        title: Text(
          country.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // --- OUTRAS INFORMAÇÕES ---
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.location_city, 'Capital: ${country.capital}'),
            _buildInfoRow(Icons.map, 'Região: ${country.region}'),
            _buildInfoRow(Icons.attach_money, 'Moeda: ${country.currency}'),
            _buildInfoRow(Icons.language, 'Língua: ${country.language}'),
          ],
        ),
        isThreeLine: true, // Garante espaço para o subtítulo
      ),
    );
  }

  // Widget auxiliar para formatar as linhas de informação
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}