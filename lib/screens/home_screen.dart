import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/movie_service.dart';
import '../widgets/movie_card.dart';
import '../models/movie.dart';

class HomeScreen extends StatelessWidget {
  final movieService = MovieService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catálogo de Películas"),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () => Navigator.pushNamed(context, '/admin'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<Movie>>(
        stream: movieService.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, i) => MovieCard(movie: movies[i]),
          );
        },
      ),
    );
  }
}
