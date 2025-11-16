// lib/services/country_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/country_model.dart';

class CountryService {
  final String _baseUrl = 'https://restcountries.com/v3.1';

  // --- FUNÇÃO 1: Para a lista da Home Screen ---
  Future<List<Country>> fetchCountries() async {
    // ADICIONAMOS 'translations' à lista de campos
    final url =
        '$_baseUrl/all?fields=name,capital,currencies,languages,region,flags,translations';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<Country> countries =
            data.map((json) => Country.fromJson(json)).toList();
        return countries;
      } else {
        throw Exception(
            'Falha ao carregar da API. Status Code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet. Verifique sua rede.');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  // --- FUNÇÃO 2: Para a Tela de Detalhes (sem mudança aqui) ---
  Future<Country> fetchCountryDetails(Country country) async {
    final url =
        '$_baseUrl/name/${country.name}?fields=population,area,subregion,borders,landlocked&fullText=true';

    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final jsonDetails = data[0];
          
          return country.copyWithDetails(
            population: jsonDetails['population'] ?? 0,
            area: (jsonDetails['area'] ?? 0.0).toDouble(),
            subregion: jsonDetails['subregion'] ?? 'N/A',
            borders: jsonDetails['borders'] != null
                ? List<String>.from(jsonDetails['borders'])
                : [],
            landlocked: jsonDetails['landlocked'] ?? false,
          );
        } else {
          throw Exception('Detalhes do país não encontrados.');
        }
      } else {
        throw Exception(
            'Falha ao carregar detalhes. Status Code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet.');
    } catch (e) {
      throw Exception('Erro inesperado nos detalhes: $e');
    }
  }
}