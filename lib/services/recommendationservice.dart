import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "9ca571e962efc2bbacbc743cc0eb8b77";
const String baseUrl = "https://api.themoviedb.org/3";

class RecommendationService {
  Future<int?> getMovieId(String movieTitle) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$movieTitle');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          return data['results'][0]['id'];
        }
      }
    } catch (e) {
      print("❌ Error fetching Movie ID: $e");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getRecommendedMovies(List<String> reviewedMovies) async {
    if (reviewedMovies.isEmpty) {
      print("⚠️ No movies reviewed. Returning empty recommendations.");
      return [];
    }

    List<Map<String, dynamic>> recommendedMovies = [];

    for (String movieTitle in reviewedMovies) {
      final movieId = await getMovieId(movieTitle);
      if (movieId == null) {
        print("⚠️ No valid Movie ID found for: $movieTitle");
        continue;
      }

      final url = Uri.parse("$baseUrl/movie/$movieId/recommendations?api_key=$apiKey&language=en-US");

      try {
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List results = data["results"];

          if (results.isNotEmpty) {
            for (var movie in results) {
              if (movie["poster_path"] != null) {
                recommendedMovies.add({
                  "title": movie["title"],
                  "posterUrl": "https://image.tmdb.org/t/p/w500${movie["poster_path"]}",
                  "rating": movie["vote_average"].toString(),
                });
              }
            }
          }
        } else {
          print("❌ Error fetching recommendations: ${response.body}");
        }
      } catch (e) {
        print("❌ Exception: $e");
      }
    }

    return recommendedMovies;
  }
}
