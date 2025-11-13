import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  /// Obtiene una lista de Pokémon con paginación
  Future<PokemonListResponse> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PokemonListResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Error al obtener la lista de Pokémon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  /// Obtiene los detalles de un Pokémon por su ID o nombre
  Future<Pokemon> getPokemonById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/pokemon/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Pokemon.fromJson(jsonData);
      } else {
        throw Exception(
            'Error al obtener el Pokémon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  /// Obtiene los detalles de un Pokémon por su nombre
  Future<Pokemon> getPokemonByName(String name) async {
    try {
      final url = Uri.parse('$baseUrl/pokemon/$name');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Pokemon.fromJson(jsonData);
      } else {
        throw Exception(
            'Error al obtener el Pokémon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}

