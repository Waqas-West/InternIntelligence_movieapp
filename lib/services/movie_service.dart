import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = "9ca571e962efc2bbacbc743cc0eb8b77";
  final String _baseUrl = "https://api.themoviedb.org/3";

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?api_key=9ca571e962efc2bbacbc743cc0eb8b77"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      List<dynamic> data = jsonData['results'] ?? [];

      return data.map((movie) {
        return {
          'id': movie['id'],
          'title': movie['title'] ?? "Untitled",
          'posterUrl': movie['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${movie['poster_path']}"
              : "https://via.placeholder.com/150",
          'description': movie['overview'] ?? "No description available.",
          'rating': (movie['vote_average'] ?? 0).toDouble(),
          'reviews': <Map<String, String>>[],
          // ✅ Ensure reviews are of correct type
        };
      }).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
