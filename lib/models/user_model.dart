class UserModel {
  final String id;
  final String name;
  final String email;
  final String profilePic;
  final List<String> watchlist; // List of movie IDs
  final List<String> favoriteGenres; // Preferred movie genres
  final List<String> reviewedMovies; // List of reviewed movie IDs
  final DateTime joinedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePic,
    required this.watchlist,
    required this.favoriteGenres,
    required this.reviewedMovies,
    required this.joinedAt,
  });

  // Convert JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePic: json['profilePic'] ?? '',
      watchlist: List<String>.from(json['watchlist'] ?? []),
      favoriteGenres: List<String>.from(json['favoriteGenres'] ?? []),
      reviewedMovies: List<String>.from(json['reviewedMovies'] ?? []),
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert UserModel to JSON (for Firestore or API calls)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'watchlist': watchlist,
      'favoriteGenres': favoriteGenres,
      'reviewedMovies': reviewedMovies,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
