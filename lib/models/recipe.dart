import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final int serves;
  final int duration;
  final int reviewCount;
  final int favouritesCount;
  final int caloriesPerServing;
  final double avgRating;
  final String id;
  final String name;
  final String imageURL;
  final String createdBy;
  final String cookbookId;
  final String description;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<String> tags;
  final List<String> steps;
  final List<String> ingredients;

  Recipe({
    @required this.name,
    @required this.createdBy,
    @required this.lastUpdated,
    this.id,
    this.tags,
    this.steps,
    this.serves,
    this.duration,
    this.imageURL,
    this.createdAt,
    this.avgRating,
    this.cookbookId,
    this.ingredients,
    this.description,
    this.reviewCount,
    this.favouritesCount,
    this.caloriesPerServing,
  });

  // create a recipe
  Map<String, dynamic> create() {
    return {
      'name': name,
      'serves': serves ?? 0,
      'createdBy': createdBy,
      'cookbookId': cookbookId,
      'duration': duration ?? 0,
      'tags': tags ?? <String>[],
      'steps': steps ?? <String>[],
      'reviewCount': reviewCount ?? 0,
      'description': description ?? "",
      'favouritesCount': favouritesCount ?? 0,
      'ingredients': ingredients ?? <String>[],
      'createdAt': Timestamp.fromDate(createdAt),
      'caloriesPerServing': caloriesPerServing ?? 0,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // create a recipe
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'serves': serves ?? 0,
      'duration': duration ?? 0,
      'tags': tags ?? <String>[],
      'steps': steps ?? <String>[],
      'reviewCount': reviewCount ?? 0,
      'description': description ?? "",
      'favouritesCount': favouritesCount ?? 0,
      'ingredients': ingredients ?? <String>[],
      'caloriesPerServing': caloriesPerServing ?? 0,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> data, String documentId) {
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

    return Recipe(
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
    );
  }

  factory Recipe.fromAlgoliaSnaphot(
      Map<String, dynamic> data, String documnetId) {
    if (data == null) {
      return null;
    }

    final int serves = data['serves'] ?? 0;
    final int duration = data['duration'] ?? 0;
    final int reviewCount = data['reviewCount'] ?? 0;
    final int favouritesCount = data['favouritesCount'] ?? 0;
    final int caloriesPerServing = data['caloriesPerServing'] ?? 0;
    final double avgRating = (data['avgRating'] ?? 0).toDouble();
    final String name = data['name'];
    final String imageURL = data['imageURL'] ?? null;
    final String createdBy = data['createdBy'] ?? null;
    final String cookbookId = data['cookbookId'] ?? null;
    final String description = data['description'] ?? null;
    final Map createdAt = data['createdAt'] ?? null;
    final Map lastUpdated = data['lastUpdated'] ?? null;
    final List tags = data['tags'] ?? <String>[];
    final List steps = data['steps'] ?? <String>[];
    final List ingredients = data['ingredients'] ?? <String>[];

    return Recipe(
      name: name,
      id: documnetId,
      serves: serves,
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
      ingredients: ingredients.map((e) => e.toString()).toList(),
      createdAt: DateTime.fromMicrosecondsSinceEpoch(createdAt["_seconds"]) ??
          DateTime.now(),
      lastUpdated:
          DateTime.fromMicrosecondsSinceEpoch(lastUpdated["_seconds"]) ??
              DateTime.now(),
    );
  }
}
