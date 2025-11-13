import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pokemon.dart';

class FirebaseService {
  FirebaseFirestore? _firestore;
  final String _collectionName = 'pokemon';

  FirebaseService() {
    // Verificar que Firebase esté inicializado antes de usar Firestore
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      _firestore = null;
    }
  }

  bool get isInitialized => _firestore != null;

  /// Guarda un Pokémon en Firestore
  Future<void> savePokemon(Pokemon pokemon) async {
    if (_firestore == null) {
      throw Exception('Firebase no está inicializado');
    }
    try {
      await _firestore!
          .collection(_collectionName)
          .doc(pokemon.id.toString())
          .set(pokemon.toMap());
    } catch (e) {
      throw Exception('Error al guardar el Pokémon: $e');
    }
  }

  /// Obtiene un Pokémon por su ID desde Firestore
  Future<Pokemon?> getPokemonById(int id) async {
    if (_firestore == null) {
      throw Exception('Firebase no está inicializado');
    }
    try {
      final doc = await _firestore!
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
    if (_firestore == null) {
      throw Exception('Firebase no está inicializado');
    }
    try {
      final querySnapshot = await _firestore!.collection(_collectionName).get();
      return querySnapshot.docs
          .where((doc) => doc.exists && doc.data().isNotEmpty)
          .map((doc) => Pokemon.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los Pokémon: $e');
    }
  }

  /// Elimina un Pokémon de Firestore
  Future<void> deletePokemon(int id) async {
    if (_firestore == null) {
      throw Exception('Firebase no está inicializado');
    }
    try {
      await _firestore!
          .collection(_collectionName)
          .doc(id.toString())
          .delete();
    } catch (e) {
      throw Exception('Error al eliminar el Pokémon: $e');
    }
  }

  /// Verifica si un Pokémon existe en Firestore
  Future<bool> pokemonExists(int id) async {
    if (_firestore == null) {
      throw Exception('Firebase no está inicializado');
    }
    try {
      final doc = await _firestore!
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
    if (_firestore == null) {
      return Stream.value([]);
    }
    return _firestore!
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) => doc.exists && doc.data().isNotEmpty)
            .map((doc) => Pokemon.fromFirestore(doc.data()))
            .toList());
  }
}

