import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/models/cookbook.dart';
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

final publicRecipesProvider = StreamProvider<List<Recipe>>(
  (ref) =>
      ref.read(firestoreRepositoryProvider).listenToPublicRecipesRealTime(),
);

final cookbooksProvider = StreamProvider<List<Cookbook>>(
  (ref) => ref.read(firestoreRepositoryProvider).listenToCookbooksRealTime(),
);

class FirestoreRepository {
  FirestoreRepository({@required this.uid}) : assert(uid != null);

  final String uid;
  final _recipeCollectionReference =
      FirebaseFirestore.instance.collection('recipes');
  final _cookbookCollectionReference =
      FirebaseFirestore.instance.collection('cookbooks');
  final _recipesController = StreamController<List<Recipe>>.broadcast();
  final _publicRecipesController = StreamController<List<Recipe>>.broadcast();
  final _cookbooksController = StreamController<List<Cookbook>>.broadcast();
  final _allPagedRecipes = List<List<Recipe>>();
  final _allPublicPagedRecipes = List<List<Recipe>>();
  final _allPagedCookbooks = List<List<Cookbook>>();

  static const int pageLimit = 10;

  DocumentSnapshot _lastRecipe;
  DocumentSnapshot _lastPublicRecipe;
  DocumentSnapshot _lastCookbook;
  bool _hasMoreRecipes = true;
  bool _hasMorePublicRecipes = true;
  bool _hasMoreCookbooks = true;

  Stream<List<Recipe>> listenToRecipesRealTime({@required String cookbookId}) {
    _requestRecipes(cookbookId: cookbookId);
    return _recipesController.stream;
  }

  Stream<List<Recipe>> listenToPublicRecipesRealTime() {
    _requestPublicRecipes();
    return _publicRecipesController.stream;
  }

  Stream<List<Cookbook>> listenToCookbooksRealTime() {
    _requestCookbooks();
    return _cookbooksController.stream;
  }

  void _requestRecipes({@required String cookbookId}) {
    Query pageRecipeQuery = _recipeCollectionReference
        .orderBy('createdAt', descending: true)
        .where('createdBy', isEqualTo: uid)
        .where('cookbookId', isEqualTo: cookbookId)
        .limit(pageLimit);

    if (_lastRecipe != null) {
      pageRecipeQuery = pageRecipeQuery.startAfterDocument(_lastRecipe);
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

          _recipesController.add(allRecipes);

          if (currentRequestIndex == _allPagedRecipes.length - 1) {
            _lastRecipe = snapshot.docs.last;
          }

          _hasMoreRecipes = generalRecipes.length == pageLimit;
        } else {
          _recipesController.addError('No Recipes Available');
        }
      },
    );
  }

  void _requestPublicRecipes() {
    Query pagePublicRecipeQuery = _recipeCollectionReference
        .orderBy('createdAt', descending: true)
        .limit(pageLimit);

    if (_lastPublicRecipe != null) {
      pagePublicRecipeQuery =
          pagePublicRecipeQuery.startAfterDocument(_lastPublicRecipe);
    }

    if (!_hasMorePublicRecipes) return;

    int currentRequestIndex = _allPublicPagedRecipes.length;

    pagePublicRecipeQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Recipe> generalPublicRecipes = snapshot.docs
              .map((snapshot) => Recipe.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPublicPagedRecipes.length;

          if (pageExists) {
            _allPublicPagedRecipes[currentRequestIndex] = generalPublicRecipes;
          } else {
            _allPublicPagedRecipes.add(generalPublicRecipes);
          }

          var allPublicRecipes = _allPublicPagedRecipes.fold<List<Recipe>>(
              List<Recipe>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _publicRecipesController.add(allPublicRecipes);

          if (currentRequestIndex == _allPublicPagedRecipes.length - 1) {
            _lastPublicRecipe = snapshot.docs.last;
          }

          _hasMorePublicRecipes = generalPublicRecipes.length == pageLimit;
        } else {
          _publicRecipesController.addError('No Recipes Available');
        }
      },
    );
  }

  void _requestCookbooks() {
    Query pageCookbookQuery = _cookbookCollectionReference
        .orderBy('createdAt', descending: true)
        .where('createdBy', isEqualTo: uid)
        .limit(pageLimit);

    if (_lastCookbook != null) {
      pageCookbookQuery = pageCookbookQuery.startAfterDocument(_lastCookbook);
    }

    if (!_hasMoreCookbooks) return;

    int currentRequestIndex = _allPagedCookbooks.length;

    pageCookbookQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Cookbook> generalCookbooks = snapshot.docs
              .map((snapshot) => Cookbook.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPagedCookbooks.length;

          if (pageExists) {
            _allPagedCookbooks[currentRequestIndex] = generalCookbooks;
          } else {
            _allPagedCookbooks.add(generalCookbooks);
          }

          var allCookbooks = _allPagedCookbooks.fold<List<Cookbook>>(
              List<Cookbook>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _cookbooksController.add(allCookbooks);

          if (currentRequestIndex == _allPagedCookbooks.length - 1) {
            _lastCookbook = snapshot.docs.last;
          }

          _hasMoreCookbooks = generalCookbooks.length == pageLimit;
        } else {
          _cookbooksController.addError('No Cookbooks Available');
        }
      },
    );
  }

  void requestMoreRecipes({@required String cookbookId}) =>
      _requestRecipes(cookbookId: cookbookId);

  void requestMorePublicRecipes() => _requestPublicRecipes();

  void requestMoreCookbooks() => _requestCookbooks();
}
