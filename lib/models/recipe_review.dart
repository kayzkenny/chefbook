import 'package:flutter/material.dart';

class RecipeReview {
  final String id;
  final String comment;
  final num rating;

  RecipeReview({
    @required this.rating,
    @required this.comment,
    this.id,
  });

  /// Convert map to map such as a firestore document
  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'comment': comment,
    };
  }

  /// Construct userData from a map sucg as a firestore document
  factory RecipeReview.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final int rating = data['rating'];
    final String comment = data['comment'];

    return RecipeReview(
      id: documentId,
      rating: rating ?? 0,
      comment: comment ?? null,
    );
  }
}
