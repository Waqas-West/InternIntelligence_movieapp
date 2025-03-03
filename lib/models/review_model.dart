class ReviewModel {
  final String userId;
  final String username;
  final String comment;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.userId,
    required this.username,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
