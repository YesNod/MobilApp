import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';

class MovieService {
  final CollectionReference moviesRef =
      FirebaseFirestore.instance.collection('movies');

  // Stream de Películas
  Stream<List<Movie>> getMovies() {
    return moviesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return Movie(
          id: doc.id,
          title: data['title'] ?? '',
          year: data['year'] ?? '',
          director: data['director'] ?? '',
          genre: data['genre'] ?? '',
          sinopsis: data['sinopsis'] ?? '',
          image: data['image'] ?? '',
        );
      }).toList();
    });
  }

  // Agregar película
  Future<void> addMovie(Movie movie) async {
    await moviesRef.add(movie.toMap());
  }

  // Eliminar película
  Future<void> deleteMovie(String id) async {
    await moviesRef.doc(id).delete();
  }
}
