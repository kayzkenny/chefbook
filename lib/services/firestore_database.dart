import 'package:meta/meta.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:chefbook/services/database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_path.dart';
import 'package:chefbook/services/firestore_service.dart';

final databaseProvider = Provider<Database>(
  (ref) => FirestoreDatabase(uid: ref.watch(authProvider).currentUser().uid),
);

final userDataProvider = StreamProvider.autoDispose<UserData>(
  (ref) => ref.read(databaseProvider).userDataStream,
);

final cookbooksProvider = StreamProvider.autoDispose<List<Cookbook>>(
  (ref) => ref.read(databaseProvider).cookbookStream,
);

final publicUserDataProvider =
    StreamProvider.autoDispose.family<UserData, String>(
  (ref, uid) => ref.read(databaseProvider).getUserStreamById(uid: uid),
);

final userRecipeProvider = StreamProvider.autoDispose.family<Recipe, String>(
  (ref, recipeId) => FirestoreDatabase(
    uid: ref.watch(authProvider).currentUser().uid,
  ).recipeStream(recipeId: recipeId),
);

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
  Stream<Recipe> recipeStream({@required String recipeId}) {
    return _service.documentStream(
      path: FirestorePath.recipe(recipeId),
      builder: (data, documentId) => Recipe.fromMap(data, documentId),
    );
  }

  @override
  Future<void> updateRecipe({@required Recipe recipe}) async {
    _service.updateData(
      path: FirestorePath.recipe(recipe.id),
      data: recipe.toMap(),
    );
  }

  @override
  Future<void> deleteRecipe({@required String recipeId}) async {
    _service.deleteData(
      path: FirestorePath.recipe(recipeId),
    );
  }

  @override
  Future<void> updateRecipeImage({
    @required String imageURL,
    @required String recipeId,
  }) async {
    _service.updateData(
      path: FirestorePath.recipe(recipeId),
      data: {"imageURL": imageURL},
    );
  }

  @override
  Future<void> deleteRecipeImage({@required String recipeId}) async {
    _service.deleteField(
      path: FirestorePath.recipe(recipeId),
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
      path: FirestorePath.userCookbooks(cookbook.id),
      data: cookbook.toMap(),
    );
  }

  @override
  Future<void> deleteCookbook({@required String cookbookId}) async {
    _service.deleteData(
      path: FirestorePath.userCookbooks(cookbookId),
    );
  }

  @override
  Future<void> updateCookbookCover({
    @required String coverURL,
    @required String cookbookID,
  }) async {
    _service.updateData(
      path: FirestorePath.userCookbooks(cookbookID),
      data: {"coverURL": coverURL},
    );
  }

  @override
  Future<void> deleteCookbookCover({@required String cookbookID}) async {
    _service.deleteField(
      path: FirestorePath.userCookbooks(cookbookID),
      fieldName: 'coverURL',
    );
  }
}
