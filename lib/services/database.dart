import 'package:chefbook/models/recipeUserFavourite.dart';
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

  Future<void> addRecipeToFavourites({@required Recipe recipe});

  Future<void> removeRecipeFromFavourites({@required String recipeId});

  /// Returns a recipe as a stream using [recipeId]
  Stream<Recipe> recipeStream({@required String recipeId});

  /// Update [recipe]
  Future<void> updateRecipe({@required Recipe recipe});

  /// Delete recipe wth [recipeId]
  Future<void> deleteRecipe({@required String recipeId});

  /// Update recipe [imageURL]
  Future<void> updateRecipeImage({
    @required String imageURL,
    @required String recipeId,
  });

  /// Delete recipe [imageURL]
  Future<void> deleteRecipeImage({@required String recipeId});

  Stream<List<Cookbook>> get cookbookStream;

  Stream<List<RecipeUserFavourite>> get favouriteRecipesStream;

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
}
