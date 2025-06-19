class PopularBioskopinaData {
  final String bioskopinaTitleEN;
  final double score;
  final int numberOfRatings;
  final String imageUrl;
  final String? director;
  final List<String>? genres; // Add genres as a nullable list of strings

  PopularBioskopinaData({
    required this.bioskopinaTitleEN,
    required this.score,
    required this.numberOfRatings,
    required this.imageUrl,
    this.director,
    this.genres,
  });

  // Add fromJson factory method if you're parsing from JSON
  factory PopularBioskopinaData.fromJson(Map<String, dynamic> json) {
    return PopularBioskopinaData(
      bioskopinaTitleEN: json['bioskopinaTitleEN'],
      score: json['score']?.toDouble() ?? 0.0,
      numberOfRatings: json['numberOfRatings'] ?? 0,
      imageUrl: json['imageUrl'],
      director: json['director'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
    );
  }
}