import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiKey = "9ca571e962efc2bbacbc743cc0eb8b77";
const String baseUrl = "https://api.themoviedb.org/3";

// Function to get movie ID by title
Future<int?> getMovieId(String movieTitle) async {
  final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$movieTitle');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['id']; // Get the first matching movie ID
      }
    }
    return null;
  } catch (e) {
    print("❌ Error fetching Movie ID: $e");
    return null;
  }
}

// Function to fetch recommendations using valid movie ID
Future<List<dynamic>> fetchRecommendations(String movieTitle) async {
  final movieId = await getMovieId(movieTitle);

  if (movieId == null) {
    print("❌ No valid Movie ID found for: $movieTitle");
    return [];
  }

  final url = Uri.parse("$baseUrl/movie/$movieId/recommendations?api_key=$apiKey");

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["results"];
    }
    print("❌ Error fetching recommendations: ${response.body}");
    return [];
  } catch (e) {
    print("❌ Exception: $e");
    return [];
  }
}
