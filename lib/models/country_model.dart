// lib/models/country_model.dart

// Classe para armazenar os dados do país de forma estruturada
class Country {
  final String name;
  final String capital;
  final String currency;
  final String language;
  final String region;
  final String flagUrl;

  Country({
    required this.name,
    required this.capital,
    required this.currency,
    required this.language,
    required this.region,
    required this.flagUrl,
  });

  // Factory constructor para criar um Country a partir do JSON da API
  // Isso lida com a estrutura complexa e dados potencialmente ausentes
  factory Country.fromJson(Map<String, dynamic> json) {
    // Função auxiliar para extrair a primeira moeda
    String getCurrency(Map<String, dynamic>? currencies) {
      if (currencies == null || currencies.isEmpty) {
        return 'N/A';
      }
      return currencies.values.first['name'] ?? 'N/A';
    }

    // Função auxiliar para extrair a primeira língua
    String getLanguage(Map<String, dynamic>? languages) {
      if (languages == null || languages.isEmpty) {
        return 'N/A';
      }
      return languages.values.first ?? 'N/A';
    }

    // Função auxiliar para extrair a capital (que é uma lista)
    String getCapital(List<dynamic>? capital) {
      if (capital == null || capital.isEmpty) {
        return 'N/A';
      }
      return capital.first ?? 'N/A';
    }

    return Country(
      name: json['name']['common'] ?? 'Nome não encontrado',
      capital: getCapital(json['capital'] as List<dynamic>?),
      currency: getCurrency(json['currencies'] as Map<String, dynamic>?),
      language: getLanguage(json['languages'] as Map<String, dynamic>?),
      region: json['region'] ?? 'N/A',
      flagUrl: json['flags']['png'] ?? '', // Pega a URL do PNG da bandeira
    );
  }
}