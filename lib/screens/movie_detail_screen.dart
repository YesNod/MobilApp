import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (movie.image.isNotEmpty)
              Center(
                child: Image.network(
                  movie.image,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 150),
                ),
              ),
            const SizedBox(height: 20),

            Text(
              movie.title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Text("Año: ${movie.year}", style: TextStyle(fontSize: 18)),
            Text("Director: ${movie.director}", style: TextStyle(fontSize: 18)),
            Text("Género: ${movie.genre}", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),
            Text(
              movie.sinopsis,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
