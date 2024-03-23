import '../models/movies_model.dart';
import 'dart:convert';

class Review {
  final Movie movie;
  final int rating;
  final String reviewText;

  Review({
    required this.movie,
    required this.rating,
    required this.reviewText,
  });

  Map<String, dynamic> toMap() {
    return {
      'movie': movie.toMap(), // Convertir el objeto Movie a Map
      'rating': rating,
      'reviewText': reviewText,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      movie:
          Movie.fromMap(map['movie']), // Crear un objeto Movie a partir del Map
      rating: map['rating'],
      reviewText: map['reviewText'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}
