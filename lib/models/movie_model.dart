import 'dart:convert';

import 'review_model.dart';

class MovieModel {
  final String id;
  final String title;
  final String posterUrl;
  final String genre;
  final String description;
  final double rating;
  final List<ReviewModel> reviews;
  final int releaseYear;
  final List<String> cast;
  final String director;
  final String trailerUrl;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.genre,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.releaseYear,
    required this.cast,
    required this.director,
    required this.trailerUrl,
  });

  // Convert JSON to MovieModel
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      genre: json['genre'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((review) => ReviewModel.fromJson(review))
          .toList() ??
          [],
      releaseYear: json['releaseYear'] ?? 0,
      cast: List<String>.from(json['cast'] ?? []),
      director: json['director'] ?? '',
      trailerUrl: json['trailerUrl'] ?? '',
    );
  }

  // Convert MovieModel to JSON (for Firestore or API calls)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'genre': genre,
      'description': description,
      'rating': rating,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'releaseYear': releaseYear,
      'cast': cast,
      'director': director,
      'trailerUrl': trailerUrl,
    };
  }
}
