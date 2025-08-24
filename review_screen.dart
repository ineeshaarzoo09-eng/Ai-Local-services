import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewScreen extends StatefulWidget {
  final String bookingId;
  final String providerId;

  ReviewScreen({required this.bookingId, required this.providerId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  String _reviewText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rate & Review')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Please rate your experience'),
              SizedBox(height: 8),
              // Simple star rating using Icons, you can use packages like flutter_rating_bar for better UI
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review here',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Please enter a review' : null,
                onSaved: (val) => _reviewText = val ?? '',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      _formKey.currentState!.save();

      // Prepare review data
      final reviewData = {
        'bookingId': widget.bookingId,
        'providerId': widget.providerId,
        'rating': _rating,
        'reviewText': _reviewText,
        'createdAt': FieldValue.serverTimestamp(),
        // You can also save customerId if you have
      };

      try {
        await FirebaseFirestore.instance.collection('reviews').add(reviewData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted successfully!')),
        );
        Navigator.pop(context); // Go back after submission
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide rating and review')),
      );
      
    }
  }
}
