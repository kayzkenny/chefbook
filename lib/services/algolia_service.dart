import 'package:algolia/algolia.dart';
import 'package:flutter/foundation.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/shared/api_keys.dart';

class AlgoliaService {
  // initialize algolia
  static Algolia algolia = Algolia.init(
    applicationId: APIKeys.AlgoliaAppId,
    apiKey: APIKeys.AlgoliaAPIKey,
  );

  /// Creates a recipe list form algolia snapshots
  List<Recipe> recipeListFromAlgolia(List<AlgoliaObjectSnapshot> snapshots) =>
      snapshots
          .map((snapshot) =>
              Recipe.fromAlgoliaSnaphot(snapshot.data, snapshot.objectID))
          .toList();

  /// Query an algolia index
  Future<List<Recipe>> queryIndex({@required String searchText}) async {
    final index = algolia.instance.index('chef-book-recipes');
    final query = index.search(searchText);
    final results = (await query.getObjects()).hits;
    return recipeListFromAlgolia(results);
  }
}
