import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddReviewWidget extends StatefulWidget {
  final Function(int rating, String reviewText) onSubmit;

  const AddReviewWidget({super.key, required this.onSubmit});

  @override
  State<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0 || _reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating and a review'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onSubmit(_rating, _reviewController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate this Movie',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating.toInt();
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Write your review...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Submit Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
