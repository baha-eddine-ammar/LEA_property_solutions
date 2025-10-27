import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PropertyReviews extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final List<Review> reviews;
  final bool showAll;

  const PropertyReviews({
    Key? key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
    this.showAll = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating summary
        Row(
          children: [
            const Icon(Icons.star, color: AppTheme.primaryColor),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: AppTheme.headingSmall,
            ),
            const SizedBox(width: 8),
            Text(
              '($reviewCount ${reviewCount == 1 ? 'review' : 'reviews'})',
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.subtitleColor),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Rating categories
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildRatingCategory('Cleanliness', 4.8),
            _buildRatingCategory('Accuracy', 4.9),
            _buildRatingCategory('Communication', 4.7),
            _buildRatingCategory('Location', 4.6),
            _buildRatingCategory('Check-in', 4.9),
            _buildRatingCategory('Value', 4.5),
          ],
        ),
        const SizedBox(height: 24),

        // Reviews
        ...reviews
            .take(showAll ? reviews.length : 3)
            .map((review) => _buildReviewItem(review))
            .toList(),

        // Show all button
        if (!showAll && reviews.length > 3)
          TextButton.icon(
            onPressed: () {
              // Navigate to all reviews page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllReviewsPage(
                    rating: rating,
                    reviewCount: reviewCount,
                    reviews: reviews,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.rate_review_outlined),
            label: Text('Show all $reviewCount reviews'),
            style: AppTheme.textButtonStyle,
          ),
      ],
    );
  }

  Widget _buildRatingCategory(String name, double score) {
    return Container(
      width: 150,
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: AppTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 8),
          // Linear progress indicator
          Container(
            width: 80,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            score.toStringAsFixed(1),
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.reviewerImage),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.reviewerName,
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    review.date,
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Review text
          Text(
            review.text,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class AllReviewsPage extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final List<Review> reviews;

  const AllReviewsPage({
    Key? key,
    required this.rating,
    required this.reviewCount,
    required this.reviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PropertyReviews(
            rating: rating,
            reviewCount: reviewCount,
            reviews: reviews,
            showAll: true,
          ),
        ],
      ),
    );
  }
}

class Review {
  final String reviewerName;
  final String reviewerImage;
  final String date;
  final String text;

  Review({
    required this.reviewerName,
    required this.reviewerImage,
    required this.date,
    required this.text,
  });
}
