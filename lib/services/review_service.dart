import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Add a review
  Future<void> addReview(String movieTitle, String reviewText,
      double rating) async {
    try {
      await _firestore.collection('reviews').add({
        "movieTitle": movieTitle,
        "reviewText": reviewText,
        "rating": rating,
        "timestamp": FieldValue.serverTimestamp(),
      });
      print("✅ Review added successfully!");
    } catch (e) {
      print("❌ Error adding review: $e");
    }
  }

  // ✅ Fetch all reviews for a specific movie
  Stream<QuerySnapshot> fetchReviews(String movieTitle) {
    return _firestore
        .collection('reviews')
        .where("movieTitle", isEqualTo: movieTitle)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  // ✅ Get a list of movies the user has reviewed
  Future<List<String>> getUserReviewedMovies() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('reviews').get();

      List<String> reviewedMovies = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return (data['movieTitle'] ?? data['title'] ?? '') as String;
      }).where((title) => title.isNotEmpty).toList();

      return reviewedMovies;
    } catch (e) {
      print("❌ Error fetching user-reviewed movies: $e");
      return [];
    }
  }
}
