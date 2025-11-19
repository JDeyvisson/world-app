import 'package:flutter/material.dart';
import '../models/country_model.dart';

class CountryCard extends StatelessWidget {
  final Country country;
  final bool isFavorite;
  final VoidCallback onToggleFavorite; 

  const CountryCard({
    Key? key,
    required this.country,
    required this.isFavorite,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            country.flagUrl,
            width: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 40,
              color: Colors.grey[200],
              child: Icon(Icons.flag, color: Colors.grey[600]),
            ),
          ),
        ),
        title: Text(
          country.namePt, 
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(Icons.location_city, 'Capital: ${country.capital}'),
            _buildInfoRow(Icons.map, 'Região: ${country.region}'),
            _buildInfoRow(Icons.attach_money, 'Moeda: ${country.currency}'),
            _buildInfoRow(Icons.language, 'Língua: ${country.language}'),
          ],
        ),
        isThreeLine: true,
        
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border, 
            color: isFavorite ? Colors.amber : Colors.grey, 
          ),
          onPressed: onToggleFavorite, 
        ),
      ),
    );
  }

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