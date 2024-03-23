import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

Future<String> loadJsonFromAsset() async {
  return await rootBundle.loadString('assets/json/movies.json');
}

List<Movie> parseJson(String response) {
  final parsed = json.decode(response).cast<Map<String, dynamic>>();
  return parsed.map<Movie>((json) => Movie.fromJson(json)).toList();
}

class Movie {
  final String name;
  final String director;
  final int year;
  final String genre;
  final String description;
  final String moviePosterPath;
  final String movieBannerPath;

  Movie({
    required this.name,
    required this.director,
    required this.year,
    required this.genre,
    required this.description,
    required this.moviePosterPath,
    required this.movieBannerPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'director': director,
      'year': year,
      'genre': genre,
      'description': description,
      'movie_poster_path': moviePosterPath,
      'movie_banner_path': movieBannerPath,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      name: map['name'],
      director: map['director'],
      year: map['year'],
      genre: map['genre'],
      description: map['description'],
      moviePosterPath: map['movie_poster_path'],
      movieBannerPath: map['movie_banner_path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(Map<String, dynamic> map) => Movie.fromMap(map);

  static Future<List<Movie>> loadMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('movies')) {
      String jsonString = await loadJsonFromAsset();
      List<Movie> movies = parseJson(jsonString);
      prefs.setString(
          'movies', jsonEncode(movies.map((movie) => movie.toMap()).toList()));
      return movies;
    } else {
      String storedMoviesString = prefs.getString('movies')!;
      List<dynamic> storedMoviesJson = jsonDecode(storedMoviesString);
      List<Movie> movies =
          storedMoviesJson.map<Movie>((json) => Movie.fromMap(json)).toList();
      return movies;
    }
  }

  String getMoviePoster() {
    return 'assets/posters/$moviePosterPath';
  }

  String getMovieBanner() {
    return 'assets/banners/$movieBannerPath';
  }

  Future<List<Movie>> getMoviesByGenre(String genre) async {
    List<Movie> movies = await loadMovies();
    return movies.where((movie) => movie.genre.contains(genre)).toList();
  }
}
