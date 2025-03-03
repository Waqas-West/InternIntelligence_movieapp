import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieDetailScreen extends StatefulWidget {
  final dynamic movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSubmitting = false;

  Future<void> submitReview() async {
    if (_reviewController.text.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      await _firestore.collection("reviews").add({
        "movie_id": widget.movie["id"],
        "movie_title": widget.movie["title"],
        "review": _reviewController.text,
        "rating": _rating,
        "timestamp": FieldValue.serverTimestamp(),
      });
      _reviewController.clear();
      setState(() {
        _rating = 3.0;
        _isSubmitting = false;
      });
    } catch (e) {
      print("Error adding review: $e");
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.movie["title"],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.movie["poster_path"] != null
                    ? "https://image.tmdb.org/t/p/w500${widget.movie["poster_path"]}"
                    : "https://via.placeholder.com/300",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // Movie Title
            Text(
              widget.movie["title"] ?? "Unknown Title",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            // Movie Overview
            Text(
              widget.movie["overview"] ?? "No description available",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),

            // Additional Details (e.g., Release Date, Rating)
            Text(
              "Release Date: ${widget.movie["release_date"] ?? "Unknown"}",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              "Rating: ${widget.movie["vote_average"]?.toStringAsFixed(1) ?? "0.0"} ⭐",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 20),

            // Reviews Section
            Text(
              "Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            // StreamBuilder to fetch and display reviews
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("reviews")
                  .where("movie_id", isEqualTo: widget.movie["id"])
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: Colors.yellow));
                }
                if (snapshot.hasError) {
                  return Text(
                    "Error loading reviews: ${snapshot.error}",
                    style: TextStyle(color: Colors.white),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text(
                    "No reviews yet. Be the first to review!",
                    style: TextStyle(color: Colors.white60),
                  );
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      color: Colors.grey[900],
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          data["review"],
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < data["rating"] ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            );
                          }),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),

            // Leave a Review Section
            Text(
              "Leave a Review",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 10),

            // Rating Bar
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            SizedBox(height: 10),

            // Review Text Field
            TextField(
              controller: _reviewController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write your review...",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Submit Review Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                //disabledBackgroundColor: Colors.black
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator(color: Colors.black)
                  : Text("Submit Review"),
            ),
          ],
        ),
      ),
    );
  }
}