import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:movieapp/screens/movie_details/movie_details.dart';

const String apiKey = "9ca571e962efc2bbacbc743cc0eb8b77";
const String baseUrl = "https://api.themoviedb.org/3";
const String imageBaseUrl = "https://image.tmdb.org/t/p/w500";

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> popularMovies = [];
  List<dynamic> recommendedMovies = [];
  Map<int, String> genreMap = {};
  int selectedGenre = 0;

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    final url = Uri.parse("$baseUrl/genre/movie/list?api_key=$apiKey");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          genreMap = {0: "All"};
          genreMap.addAll({for (var genre in data['genres']) genre['id']: genre['name']});
        });
        fetchMoviesByGenre(0);
      }
    } catch (e) {
      print("Error fetching genres: $e");
    }
  }

  Future<void> fetchMoviesByGenre(int genreId) async {
    final randomPage = Random().nextInt(10) + 1;
    final url = genreId == 0
        ? Uri.parse("$baseUrl/movie/popular?api_key=$apiKey&page=$randomPage")
        : Uri.parse("$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId&page=$randomPage");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          popularMovies = data["results"];
          fetchRecommendedMovies();
        });
      }
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  Future<void> fetchRecommendedMovies() async {
    if (popularMovies.isEmpty) return;
    final randomMovie = popularMovies[Random().nextInt(popularMovies.length)];
    final movieId = randomMovie["id"];
    final url = Uri.parse("$baseUrl/movie/$movieId/recommendations?api_key=$apiKey");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          recommendedMovies = data["results"];
        });
      }
    } catch (e) {
      print("Error fetching recommendations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Darker purple background
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true, // Centers the title
        title: const Text(
          "Movie App",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black, // Lighter purple for contrast
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              height: 50,
              child: genreMap.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genreMap.length,
                itemBuilder: (context, index) {
                  int genreId = genreMap.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedGenre = genreId;
                      });
                      fetchMoviesByGenre(genreId);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: selectedGenre == genreId ? Colors.red : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          genreMap[genreId]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  movieSection("Popular Movies", popularMovies),
                  movieSection("Recommended Movies", recommendedMovies),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget movieSection(String title, List<dynamic> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: movies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    movie["poster_path"] != null
                        ? "$imageBaseUrl${movie["poster_path"]}"
                        : "https://via.placeholder.com/300",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              movie["title"] ?? "Unknown Title",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
