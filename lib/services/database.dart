import 'package:meta/meta.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/models/cookbook.dart';

abstract class Database {
  // User operations
  /// Return [UserData] as a stream
  Stream<UserData> get userDataStream;

  /// Updates user data with [UserData]
  Future<void> updateUserData({@required UserData userData});

  /// Get [UserData] using [uid]
  Stream<UserData> getUserStreamById({@required String uid});

  /// Delete user avatar
  Future<void> deleteUserAvatar();

  /// Update user avatar with [avatar]
  Future<void> updateUserAvatar({@required String avatar});

  // Recipe operations
  /// Create a [recipe]
  Future<void> createRecipe({@required Recipe recipe});

  /// Returns a recipe as a stream using [recipeId]
  Stream<Recipe> recipeStream({@required String recipeId});

  /// Update [recipe]
  Future<void> updateRecipe({@required Recipe recipe});

  /// Delete recipe wth [recipeId]
  Future<void> deleteRecipe({@required String recipeId});

  /// Add recipe to favourites array with [recipeId]
  Future<void> addToFavourites({@required String recipeId});

  /// Remove recipe form favourites array with [recipeId]
  Future<void> removeFromFavourites({@required String recipeId});

  /// Get recipes favourites with [recipeIds]
  Future<List<Recipe>> getFavourites({@required List<String> recipeIds});

  /// Get following with [uids]
  Future<List<UserData>> getFollowing({@required List<String> uids});

  /// Get followers with [uids]
  Future<List<UserData>> getFollowers({@required List<String> uids});

  /// Update recipe [imageURL]
  Future<void> updateRecipeImage({
    @required String imageURL,
    @required String recipeId,
  });

  /// Delete recipe [imageURL]
  Future<void> deleteRecipeImage({@required String recipeId});

  /// Get initial recipes with [cookbookId]
  Future<List<Recipe>> getFirstRecipesByCookbookId({
    @required String cookbookId,
  });

  /// Get initial recipes with [uid]
  Future<List<Recipe>> getFirstRecipesByUID({@required String uid});

  /// Get initial recipes with [uid]
  Future<List<Recipe>> getMoreRecipesByUID({@required String uid});

  /// Get more recipes with [cookbookId]
  Future<List<Recipe>> getMoreRecipesByCookbookId({
    @required String cookbookId,
  });

  /// Get initial recipes
  Future<List<Recipe>> get getFirstRecipes;

  /// Get more recipes
  Future<List<Recipe>> get getMoreRecipes;

  // Cookbook operations
  /// Create [cookbook]
  Future<void> createCookbook({@required Cookbook cookbook});

  /// Delete cookbook with [cookbookId]
  Future<void> deleteCookbook({@required String cookbookId});

  /// Update [cookbook]
  Future<void> updateCookbook({@required Cookbook cookbook});

  /// Delete coobookcover with [cookbookID]
  Future<void> deleteCookbookCover({@required String cookbookID});

  /// Update cookbook cover
  Future<void> updateCookbookCover({
    @required String coverURL,
    @required String cookbookID,
  });

  /// Get initial cookbooks
  Future<List<Cookbook>> get getFirstCookbooks;

  /// Get more cookbooks
  Future<List<Cookbook>> get getMoreCookbooks;
}
