class Country {
  final String name; 
  final String namePt; 
  final String capital;
  final String currency;
  final String language;
  final String region;
  final String flagUrl;

  final int? population;
  final double? area;
  final String? subregion;
  final List<String>? borders;
  final bool? landlocked;

  Country({
    required this.name,
    required this.namePt, 
    required this.capital,
    required this.currency,
    required this.language,
    required this.region,
    required this.flagUrl,
    this.population,
    this.area,
    this.subregion,
    this.borders,
    this.landlocked,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    String getCurrency(Map<String, dynamic>? currencies) {
      if (currencies == null || currencies.isEmpty) return 'N/A';
      return currencies.values.first['name'] ?? 'N/A';
    }

    String getLanguage(Map<String, dynamic>? languages) {
      if (languages == null || languages.isEmpty) return 'N/A';
      return languages.values.first ?? 'N/A';
    }

    String getCapital(List<dynamic>? capital) {
      if (capital == null || capital.isEmpty) return 'N/A';
      return capital.first ?? 'N/A';
    }

    String getNamePt(
        Map<String, dynamic>? translations, String defaultName) {
      if (translations == null) return defaultName;
      
      if (translations['por'] != null && translations['por']['common'] != null) {
        return translations['por']['common'];
      }

      return defaultName;
    }

    final defaultName = json['name']['common'] ?? 'Nome não encontrado';

    return Country(
      name: defaultName,
      namePt: getNamePt(json['translations'] as Map<String, dynamic>?, defaultName), 
      capital: getCapital(json['capital'] as List<dynamic>?),
      currency: getCurrency(json['currencies'] as Map<String, dynamic>?),
      language: getLanguage(json['languages'] as Map<String, dynamic>?),
      region: json['region'] ?? 'N/A',
      flagUrl: json['flags']['png'] ?? '',
      
      population: json['population'] as int?,
      area: (json['area'] as num?)?.toDouble(),
      subregion: json['subregion'] as String?,
      borders: json['borders'] != null
          ? List<String>.from(json['borders'])
          : null,
      landlocked: json['landlocked'] as bool?,
    );
  }

  Country copyWithDetails({
    required int population,
    required double area,
    required String subregion,
    required List<String> borders,
    required bool landlocked,
  }) {
    return Country(
      name: this.name,
      namePt: this.namePt, 
      capital: this.capital,
      currency: this.currency,
      language: this.language,
      region: this.region,
      flagUrl: this.flagUrl,
      population: population,
      area: area,
      subregion: subregion,
      borders: borders,
      landlocked: landlocked,
    );
  }
}