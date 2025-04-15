import 'package:flutter/material.dart';
import 'package:safe_travels_3/config/theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;
  final Color? color;

  const StarRating({
    Key? key,
    required this.rating,
    this.size = 24.0,
    this.isInteractive = false,
    this.onRatingChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          final int starValue = index + 1;
          return IconButton(
            padding: const EdgeInsets.symmetric(horizontal: -4), // Negative padding to bring stars closer
            constraints: const BoxConstraints(),
            onPressed: isInteractive
                ? () => onRatingChanged?.call(starValue.toDouble())
                : null,
            icon: Icon(
              starValue <= rating ? Icons.star : Icons.star_border,
              color: color ?? AppTheme.secondaryYellow,
              size: size,
            ),
            splashRadius: size * 0.8,
            tooltip: isInteractive ? '$starValue stars' : null,
          );
        }),
      ),
    );
  }
}

class CategoryRating extends StatelessWidget {
  final String category;
  final double rating;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const CategoryRating({
    Key? key,
    required this.category,
    required this.rating,
    this.isInteractive = false,
    this.onRatingChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            category,
            style: const TextStyle(
              fontSize: AppTheme.bodyFontSize,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: StarRating(
            rating: rating,
            size: 24,
            isInteractive: isInteractive,
            onRatingChanged: isInteractive ? onRatingChanged : null,
          ),
        ),
      ],
    );
  }
}
