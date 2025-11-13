import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'pokemon';

  /// Guarda un Pokémon en Firestore
  Future<void> savePokemon(Pokemon pokemon) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(pokemon.id.toString())
          .set(pokemon.toMap());
    } catch (e) {
      throw Exception('Error al guardar el Pokémon: $e');
    }
  }

  /// Obtiene un Pokémon por su ID desde Firestore
  Future<Pokemon?> getPokemonById(int id) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(id.toString())
          .get();

      if (doc.exists) {
        return Pokemon.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el Pokémon: $e');
    }
  }

  /// Obtiene todos los Pokémon guardados en Firestore
  Future<List<Pokemon>> getAllPokemon() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionName).get();
      return querySnapshot.docs
          .map((doc) => Pokemon.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los Pokémon: $e');
    }
  }

  /// Elimina un Pokémon de Firestore
  Future<void> deletePokemon(int id) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id.toString())
          .delete();
    } catch (e) {
      throw Exception('Error al eliminar el Pokémon: $e');
    }
  }

  /// Verifica si un Pokémon existe en Firestore
  Future<bool> pokemonExists(int id) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(id.toString())
          .get();
      return doc.exists;
    } catch (e) {
      throw Exception('Error al verificar el Pokémon: $e');
    }
  }

  /// Escucha cambios en tiempo real de la colección de Pokémon
  Stream<List<Pokemon>> watchPokemon() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pokemon.fromFirestore(doc.data()))
            .toList());
  }
}

