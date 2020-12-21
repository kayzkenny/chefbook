import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>(
  (ref) => FirestoreRepository(uid: ref.watch(authProvider).currentUser().uid),
);

// removed autodispose becasue when the recipes page was closed and repopened
// the page was loading forever
final recipesProvider = StreamProvider.family<List<Recipe>, String>(
  (ref, cookbookId) => ref
      .read(firestoreRepositoryProvider)
      .listenToRecipesRealTime(cookbookId: cookbookId),
);

class FirestoreRepository {
  FirestoreRepository({@required this.uid}) : assert(uid != null);

  final String uid;
  final _recipeCollectionReference =
      FirebaseFirestore.instance.collection('recipes');
  final _recipeController = StreamController<List<Recipe>>.broadcast();

  List<List<Recipe>> _allPagedRecipes = List<List<Recipe>>();

  static const int recipePageLimit = 10;
  DocumentSnapshot _lastRecipeDocument;
  bool _hasMoreRecipes = true;

  Stream<List<Recipe>> listenToRecipesRealTime({@required String cookbookId}) {
    _requestRecipes(cookbookId: cookbookId);
    return _recipeController.stream;
  }

  void _requestRecipes({@required String cookbookId}) {
    Query pageRecipeQuery = _recipeCollectionReference
        .orderBy('createdAt', descending: true)
        .where('createdBy', isEqualTo: uid)
        .where('cookbookId', isEqualTo: cookbookId)
        .limit(recipePageLimit);

    if (_lastRecipeDocument != null) {
      pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastRecipeDocument);
    }

    if (!_hasMoreRecipes) return;

    int currentRequestIndex = _allPagedRecipes.length;

    pageRecipeQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Recipe> generalRecipes = snapshot.docs
              .map((snapshot) => Recipe.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPagedRecipes.length;

          if (pageExists) {
            _allPagedRecipes[currentRequestIndex] = generalRecipes;
          } else {
            _allPagedRecipes.add(generalRecipes);
          }

          var allRecipes = _allPagedRecipes.fold<List<Recipe>>(List<Recipe>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _recipeController.add(allRecipes);

          if (currentRequestIndex == _allPagedRecipes.length - 1) {
            _lastRecipeDocument = snapshot.docs.last;
          }

          _hasMoreRecipes = generalRecipes.length == recipePageLimit;
        }
      },
    );
  }

  void requestMoreRecipes({@required String cookbookId}) =>
      _requestRecipes(cookbookId: cookbookId);
}
