import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cookbook {
  final String id;
  final String name;
  final String coverURL;
  final String createdBy;
  final int recipeCount;
  final DateTime createdAt;
  final DateTime lastUpdated;

  Cookbook({
    @required this.name,
    @required this.lastUpdated,
    this.id,
    this.recipeCount,
    this.coverURL,
    this.createdBy,
    this.createdAt,
  });

  /// Convert userData to map such as a firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // create a cookbook
  Map<String, dynamic> create() {
    return {
      'name': name,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  /// Construct userData from a map sucg as a firestore document
  factory Cookbook.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String id = documentId;
    final String name = data['name'];
    final String coverURL = data['coverURL'];
    final String createdBy = data['createdBy'];
    final int recipeCount = data['recipesCount'];
    final Timestamp createdAt = data['createdAt'];
    final Timestamp lastUpdated = data['lastUpdated'];

    return Cookbook(
      id: id,
      name: name,
      createdBy: createdBy,
      coverURL: coverURL ?? null,
      createdAt: createdAt.toDate(),
      lastUpdated: lastUpdated.toDate(),
      recipeCount: recipeCount ?? null,
    );
  }
}
