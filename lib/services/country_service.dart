// lib/services/country_service.dart

import 'dart:convert';
import 'dart:io'; // Precisamos disso para capturar erros de rede
import 'package:http/http.dart' as http;
import '../models/country_model.dart'; // Importa o modelo

class CountryService {
  // 1. VERIFIQUE SE A SUA URL ESTÁ EXATAMENTE ASSIM:
  final String _baseUrl =
      'https://restcountries.com/v3.1/all?fields=name,capital,currencies,languages,region,flags';

  // Função para buscar os dados da API
  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      // 2. Verifica se a chamada foi bem-sucedida
      if (response.statusCode == 200) {
        // Decodifica o JSON (que é uma lista de países)
        final List<dynamic> data = json.decode(response.body);

        // Converte cada item do JSON em um objeto Country
        final List<Country> countries =
            data.map((json) => Country.fromJson(json)).toList();

        return countries;
      } else {
        // 3. Se a API retornar um erro, mostra o Status Code
        throw Exception(
            'Falha ao carregar da API. Status Code: ${response.statusCode}');
      }
    } on SocketException {
      // 4. Captura erro se o dispositivo estiver offline
      throw Exception('Sem conexão com a internet. Verifique sua rede.');
    } on http.ClientException {
      // 5. Captura outros erros de conexão
      throw Exception('Erro ao tentar conectar ao servidor.');
    } catch (e) {
      // 6. Captura qualquer outro erro (parsing de JSON, etc)
      throw Exception('Erro inesperado: $e');
    }
  }
}