class Movie {
  final String id;
  final String title;
  final String year;
  final String director;
  final String genre;
  final String sinopsis;
  final String image;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.sinopsis,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'sinopsis': sinopsis,
      'image': image,
    };
  }
}
