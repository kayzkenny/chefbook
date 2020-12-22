import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeUserFavourite {
  final Recipe recipe;
  final bool isFavourite;

  RecipeUserFavourite({
    @required this.recipe,
    @required this.isFavourite,
  });

  // create favourite
  Map<String, dynamic> toMap() {
    return {
      'name': recipe.name,
      'serves': recipe.serves ?? 0,
      'duration': recipe.duration ?? 0,
      'tags': recipe.tags ?? <String>[],
      'steps': recipe.steps ?? <String>[],
      'reviewCount': recipe.reviewCount ?? 0,
      'description': recipe.description ?? "",
      'favouritesCount': recipe.favouritesCount ?? 0,
      'ingredients': recipe.ingredients ?? <String>[],
      'caloriesPerServing': recipe.caloriesPerServing ?? 0,
      'lastUpdated': Timestamp.fromDate(recipe.lastUpdated),
    };
  }

  factory RecipeUserFavourite.fromMap(
      Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String name = data['name'];
    if (name == null) {
      return null;
    }

    final int serves = data['serves'] ?? 0;
    final int duration = data['duration'] ?? 0;
    final int reviewCount = data['reviewCount'] ?? 0;
    final int favouritesCount = data['favouritesCount'] ?? 0;
    final int caloriesPerServing = data['caloriesPerServing'] ?? 0;
    final double avgRating = (data['avgRating'] ?? 0).toDouble();
    final String imageURL = data['imageURL'] ?? null;
    final String createdBy = data['createdBy'] ?? null;
    final String cookbookId = data['cookbookId'] ?? null;
    final String description = data['description'] ?? null;
    final Timestamp createdAt = data['createdAt'] ?? null;
    final Timestamp lastUpdated = data['lastUpdated'] ?? null;
    final List tags = data['tags'] ?? <String>[];
    final List steps = data['steps'] ?? <String>[];
    final List ingredients = data['ingredients'] ?? <String>[];

    return RecipeUserFavourite(
      recipe: Recipe(
        name: name,
        serves: serves,
        id: documentId,
        duration: duration,
        imageURL: imageURL,
        avgRating: avgRating,
        createdBy: createdBy,
        cookbookId: cookbookId,
        description: description,
        reviewCount: reviewCount,
        favouritesCount: favouritesCount,
        caloriesPerServing: caloriesPerServing,
        tags: tags.map((e) => e.toString()).toList(),
        steps: steps.map((e) => e.toString()).toList(),
        createdAt: createdAt?.toDate() ?? DateTime.now(),
        lastUpdated: lastUpdated?.toDate() ?? DateTime.now(),
        ingredients: ingredients.map((e) => e.toString()).toList(),
      ),
      isFavourite: true,
    );
  }
}
