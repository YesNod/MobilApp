import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: (movie.image.isNotEmpty)
            ? Image.network(
                movie.image,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
              )
            : const Icon(Icons.image_not_supported, size: 40),
        title: Text(movie.title),
        subtitle: Text(movie.genre),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailScreen(movie: movie),
            ),
          );
        },
      ),
    );
  }
}
