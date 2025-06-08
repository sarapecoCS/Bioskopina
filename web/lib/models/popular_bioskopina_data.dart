class PopularBioskopinaData {
  final String bioskopinaTitleEN;

  final double score;
  final int numberOfRatings;
  final String imageUrl;
  final String? director; // Make it nullable if not always present

  PopularBioskopinaData({
    required this.bioskopinaTitleEN,

    required this.score,
    required this.numberOfRatings,
    required this.imageUrl,
    this.director,  // Optional named parameter
  });
}
