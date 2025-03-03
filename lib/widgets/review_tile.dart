import 'package:flutter/material.dart';

class ReviewTile extends StatefulWidget {
  final String username;
  final String review;
  final Function(String)? onReviewSubmitted;

  const ReviewTile({
    Key? key,
    required this.username,
    required this.review,
    this.onReviewSubmitted,
  }) : super(key: key);

  @override
  _ReviewTileState createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  final TextEditingController _reviewController = TextEditingController();
  List<Map<String, String>> reviews = []; // Store reviews locally

  void _submitReview() {
    if (_reviewController.text.isNotEmpty) {
      setState(() {
        reviews.add({
          'username': widget.username,
          'review': _reviewController.text,
        });
      });
      _reviewController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _reviewController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Write a review...",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.blueGrey.shade700,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text("Submit Review"),
            ),
            const SizedBox(height: 10),
            if (reviews.isNotEmpty)
              Column(
                children: reviews
                    .map((review) => ListTile(
                  title: Text(review['username']!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(review['review']!, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
