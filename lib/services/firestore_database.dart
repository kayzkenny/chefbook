import 'package:chefbook/models/recipe_review.dart';
import 'package:meta/meta.dart';
// import 'package:rxdart/rxdart.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:chefbook/services/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_path.dart';
import 'package:chefbook/models/recipe_user_favourite.dart';
import 'package:chefbook/services/firestore_service.dart';

final databaseProvider = Provider<Database>(
  (ref) => FirestoreDatabase(uid: ref.watch(authProvider).currentUser().uid),
);

final allFollowingProvider = StreamProvider<List<UserData>>(
  (ref) => ref.read(databaseProvider).followingStream,
);

// final userDataProvider = StreamProvider<UserData>(
//   (ref) => ref.read(databaseProvider).userDataStream,
// );

// final publicUserDataProvider = StreamProvider.family<UserData, String>(
//   (ref, uid) => ref.read(databaseProvider).getUserStreamById(uid: uid),
// );

// final userRecipeProvider = StreamProvider.family<Recipe, String>(
//   (ref, recipeId) => FirestoreDatabase(
//     uid: ref.watch(authProvider).currentUser().uid,
//   ).recipeStream(recipeId: recipeId),
// );

// final allFavouriteRecipesProvider = StreamProvider<List<RecipeUserFavourite>>(
//   (ref) => ref.read(databaseProvider).favouriteRecipesStream,
// );

// final favouriteRecipeProvider =
//     StreamProvider.family<RecipeUserFavourite, String>((ref, recipeId) {
//   final recipe = ref.watch(userRecipeProvider(recipeId).stream);
//   final favouritesList = ref.watch(allFavouriteRecipesProvider.stream);

//   return Rx.combineLatest2(
//     recipe,
//     favouritesList,
//     (Recipe recipe, List<RecipeUserFavourite> favouritesList) {
//       final userFav = favouritesList.firstWhere(
//         (fav) => fav.recipe.id == recipe.id,
//         orElse: () => null,
//       );
//       return RecipeUserFavourite(
//         recipe: recipe,
//         isFavourite: userFav?.isFavourite ?? false,
//       );
//     },
//   );
// });

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FirestoreService.instance;

  static const int PageLimit = 10;

  @override
  Stream<UserData> get userDataStream {
    return _service.documentStream(
      path: FirestorePath.userData(uid),
      builder: (data, documentId) => UserData.fromMap(data, documentId),
    );
  }

  @override
  Future<void> updateUserData({@required UserData userData}) async {
    _service.updateData(
      path: FirestorePath.userData(uid),
      data: userData.toMap(),
    );
  }

  @override
  Stream<UserData> getUserStreamById({@required String uid}) {
    return _service.documentStream(
      path: FirestorePath.userData(uid),
      builder: (data, documentId) => UserData.fromMap(data, documentId),
    );
  }

  @override
  Future<void> deleteUserAvatar() async {
    _service.deleteField(
      path: FirestorePath.userData(uid),
      fieldName: 'avatar',
    );
  }

  @override
  Future<void> updateUserAvatar({@required String avatar}) async {
    _service.updateData(
      path: FirestorePath.userData(uid),
      data: {"avatar": avatar},
    );
  }

  @override
  Future<void> createRecipe({@required Recipe recipe}) async {
    _service.addData(
      path: FirestorePath.recipes(),
      data: recipe.create(),
    );
  }

  @override
  Future<void> setReview({
    @required String recipeId,
    @required RecipeReview recipeReview,
  }) async {
    _service.setData(
      path: FirestorePath.recipeReview(recipeId, uid),
      data: recipeReview.toMap(),
    );
  }

  @override
  Future<void> deleteReview({
    @required String recipeId,
    @required String reviewId,
  }) async {
    _service.deleteData(path: FirestorePath.recipeReview(recipeId, reviewId));
  }

  @override
  Future<void> addRecipeToFavourites({@required Recipe recipe}) async {
    _service.setData(
      path: FirestorePath.userFavouriteRecipe(uid, recipe.id),
      data: recipe.toMap(),
    );
  }

  @override
  Future<void> followUser({@required UserData userData}) async {
    _service.setData(
      path: FirestorePath.following(uid, userData.uid),
      data: userData.toNetwork(),
    );
  }

  @override
  Future<void> unfollowUser({@required String publicUID}) async {
    _service.deleteData(
      path: FirestorePath.following(uid, publicUID),
    );
  }

  @override
  Future<void> removeRecipeFromFavourites({@required String recipeId}) async {
    _service.deleteData(
      path: FirestorePath.userFavouriteRecipe(uid, recipeId),
    );
  }

  @override
  Stream<Recipe> recipeStream({@required String recipeId}) {
    return _service.documentStream(
      path: FirestorePath.userRecipe(recipeId),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
    );
  }

  @override
  Future<void> updateRecipe({@required Recipe recipe}) async {
    _service.updateData(
      path: FirestorePath.userRecipe(recipe.id),
      data: recipe.toMap(),
    );
  }

  @override
  Future<void> deleteRecipe({@required String recipeId}) async {
    _service.deleteData(
      path: FirestorePath.userRecipe(recipeId),
    );
  }

  @override
  Future<void> updateRecipeImage({
    @required String imageURL,
    @required String recipeId,
  }) async {
    _service.updateData(
      path: FirestorePath.userRecipe(recipeId),
      data: {"imageURL": imageURL},
    );
  }

  @override
  Future<void> deleteRecipeImage({@required String recipeId}) async {
    _service.deleteField(
      path: FirestorePath.userRecipe(recipeId),
      fieldName: 'imageURL',
    );
  }

  @override
  Stream<List<Cookbook>> get cookbookStream {
    return _service.collectionStream(
      path: FirestorePath.cookbooks(),
      queryBuilder: (query) => query.where('createdBy', isEqualTo: uid),
      builder: (data, documentId) => Cookbook.fromMap(data, documentId),
    );
  }

  @override
  Stream<List<UserData>> get followingStream {
    return _service.collectionStream(
      path: FirestorePath.allFollowing(uid),
      builder: (data, documentId) => UserData.fromMap(data, documentId),
    );
  }

  Stream<List<RecipeUserFavourite>> get favouriteRecipesStream {
    return _service.collectionStream(
      path: FirestorePath.userFavourites(uid),
      builder: (data, documentId) =>
          RecipeUserFavourite.fromMap(data, documentId),
    );
  }

  @override
  Future<List<Recipe>> getMoreRecipesByCookbookId({
    @required String cookbookId,
  }) async {
    return await _service.paginatedCollectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('lastUpdated', descending: true)
          .where('createdBy', isEqualTo: uid)
          .where('cookbookId', isEqualTo: cookbookId)
          .limit(PageLimit),
    );
  }

  @override
  Future<List<Recipe>> getFirstRecipesByCookbookId({
    @required String cookbookId,
  }) async {
    return await _service.collectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('lastUpdated', descending: true)
          .where('createdBy', isEqualTo: uid)
          .where('cookbookId', isEqualTo: cookbookId)
          .limit(PageLimit),
    );
  }

  @override
  Future<List<Recipe>> get getFirstRecipes async {
    return await _service.collectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.orderBy('lastUpdated', descending: true).limit(PageLimit),
    );
  }

  @override
  Future<List<Recipe>> get getMoreRecipes async {
    return await _service.paginatedCollectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) =>
          query.orderBy('lastUpdated', descending: true).limit(PageLimit),
    );
  }

  @override
  Future<List<Recipe>> getFirstRecipesByUID({@required String uid}) async {
    return await _service.collectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('lastUpdated', descending: true)
          .where('createdBy', isEqualTo: uid)
          .limit(PageLimit),
    );
  }

  @override
  Future<List<Recipe>> getMoreRecipesByUID({@required String uid}) async {
    return await _service.collectionList(
      path: FirestorePath.recipes(),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
      queryBuilder: (query) => query
          .orderBy('lastUpdated', descending: true)
          .where('createdBy', isEqualTo: uid)
          .limit(PageLimit),
    );
  }

  @override
  Future<void> createCookbook({@required Cookbook cookbook}) async {
    _service.addData(
      path: FirestorePath.cookbooks(),
      data: cookbook.create(),
    );
  }

  @override
  Future<void> updateCookbook({@required Cookbook cookbook}) async {
    _service.updateData(
      path: FirestorePath.userCookbook(cookbook.id),
      data: cookbook.toMap(),
    );
  }

  @override
  Future<void> deleteCookbook({@required String cookbookId}) async {
    _service.deleteData(
      path: FirestorePath.userCookbook(cookbookId),
    );
  }

  @override
  Future<void> updateCookbookCover({
    @required String coverURL,
    @required String cookbookID,
  }) async {
    _service.updateData(
      path: FirestorePath.userCookbook(cookbookID),
      data: {"coverURL": coverURL},
    );
  }

  @override
  Future<void> deleteCookbookCover({@required String cookbookID}) async {
    _service.deleteField(
      path: FirestorePath.userCookbook(cookbookID),
      fieldName: 'coverURL',
    );
  }
}
