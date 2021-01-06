import 'dart:async';

import 'package:chefbook/models/user_data_social.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chefbook/models/recipe_user_favourite.dart';

final firestoreRepositoryProvider = Provider<FirestoreRepository>(
  (ref) => FirestoreRepository(uid: ref.watch(authProvider).currentUser().uid),
);

final recipesProvider =
    StreamProvider.family<List<Recipe>, String>((ref, cookbookId) {
  // ref.onDispose(
  //     () => ref.read(firestoreRepositoryProvider).closeRecipesController());
  return ref
      .read(firestoreRepositoryProvider)
      .listenToRecipesRealTime(cookbookId: cookbookId);
});

final userRecipeProvider =
    StreamProvider.autoDispose.family<Recipe, String>((ref, recipeId) {
  ref.onDispose(
      () => ref.read(firestoreRepositoryProvider).closeUserRecipeController());
  return ref
      .read(firestoreRepositoryProvider)
      .listenToUserRecipeRealTime(recipeId: recipeId);
});

final allFavouriteRecipesProvider =
    StreamProvider.autoDispose<List<RecipeUserFavourite>>((ref) {
  ref.onDispose(() =>
      ref.read(firestoreRepositoryProvider).closeAllFavouritesController());
  return ref
      .read(firestoreRepositoryProvider)
      .listenToAllFavouriteRecipesRealTime();
});

// final allFollowingProvider = StreamProvider<List<UserDataSocial>>((ref) {
//   // ref.onDispose(() =>
//   //     ref.read(firestoreRepositoryProvider).closeAllFollowingController());
//   return ref.read(firestoreRepositoryProvider).listenToAllUserFollowing();
// });

final favouriteRecipeProvider = StreamProvider.autoDispose
    .family<RecipeUserFavourite, String>((ref, recipeId) {
  final recipe = ref.watch(userRecipeProvider(recipeId).stream);
  final favouritesList = ref.watch(allFavouriteRecipesProvider.stream);

  ref.onDispose(() {
    ref.read(firestoreRepositoryProvider).closeUserRecipeController();
    ref.read(firestoreRepositoryProvider).closeAllFavouritesController();
  });

  return Rx.combineLatest2(
    recipe,
    favouritesList,
    (Recipe recipe, List<RecipeUserFavourite> favouritesList) {
      final userFav = favouritesList.firstWhere(
        (fav) => fav.recipe.id == recipe.id,
        orElse: () => null,
      );
      return RecipeUserFavourite(
        recipe: recipe,
        isFavourite: userFav?.isFavourite ?? false,
      );
    },
  );
});

// final userDataSocialProvider =
//     StreamProvider.family<UserDataSocial, String>((ref, publicUid) {
//   print('/////////////////////');
//   final allFollowing = ref.watch(allFollowingProvider.stream);
//   final publicUserData = ref.watch(publicUserDataProvider(publicUid).stream);

//   ref.onDispose(() {
//     ref.read(firestoreRepositoryProvider).closeAllFollowingController();
//     // ref.read(firestoreRepositoryProvider).closePublicUserDataController();
//   });

//   print(allFollowing?.length);

//   return Rx.combineLatest2(
//     publicUserData,
//     allFollowing,
//     (UserData publicUserData, List<UserDataSocial> allFollowing) {
//       final userData = allFollowing.firstWhere(
//         (followed) => followed.userData.uid == publicUserData.uid,
//         orElse: () => null,
//       );
//       return UserDataSocial(
//         userData: publicUserData,
//         isFollowed: userData?.isFollowed ?? false,
//       );
//     },
//   );
// });

final publicRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  // ref.onDispose(() =>
  //     ref.read(firestoreRepositoryProvider).closePublicRecipesController());
  return ref.read(firestoreRepositoryProvider).listenToPublicRecipesRealTime();
});

final cookbooksProvider = StreamProvider<List<Cookbook>>((ref) {
  // ref.onDispose(
  //     () => ref.read(firestoreRepositoryProvider).closeCookbooksController());
  return ref.read(firestoreRepositoryProvider).listenToCookbooksRealTime();
});

final paginatedFavouriteRecipesProvider = StreamProvider<List<Recipe>>((ref) {
  // ref.onDispose(
  //     () => ref.read(firestoreRepositoryProvider).closeFavouritesController());
  return ref
      .read(firestoreRepositoryProvider)
      .listenToFavouriteRecipesRealTime();
});

final paginatedFollowingProvider = StreamProvider<List<UserData>>((ref) {
  // ref.onDispose(() =>
  //     ref.read(firestoreRepositoryProvider).closeUserFollowingController());
  return ref.read(firestoreRepositoryProvider).listenToUserFollowingRealTime();
});

final paginatedFollowersProvider = StreamProvider<List<UserData>>((ref) {
  // ref.onDispose(() =>
  //     ref.read(firestoreRepositoryProvider).closeUserFollowersController());
  return ref.read(firestoreRepositoryProvider).listenToUserFollowersRealTime();
});

final userDataProvider = StreamProvider<UserData>((ref) {
  // ref.onDispose(
  //     () => ref.read(firestoreRepositoryProvider).closeUserDataController());
  return ref.read(firestoreRepositoryProvider).listenToUserDataRealTime();
});

final publicUserDataProvider =
    StreamProvider.family<UserData, String>((ref, uid) {
  // ref.onDispose(() =>
  //     ref.read(firestoreRepositoryProvider).closePublicUserDataController());
  return ref
      .read(firestoreRepositoryProvider)
      .listenToPublicUserDataRealTime(uid);
});

class FirestoreRepository {
  FirestoreRepository({@required this.uid}) : assert(uid != null);

  final String uid;
  final _recipeCollectionReference =
      FirebaseFirestore.instance.collection('recipes');
  final _cookbookCollectionReference =
      FirebaseFirestore.instance.collection('cookbooks');
  final _userRecipeController = StreamController<Recipe>.broadcast();
  final _userDataController = StreamController<UserData>.broadcast();
  final _recipesController = StreamController<List<Recipe>>.broadcast();
  final _favouritesController = StreamController<List<Recipe>>.broadcast();
  // final _publicUserDataController = StreamController<UserData>.broadcast();
  final _cookbooksController = StreamController<List<Cookbook>>.broadcast();
  final _publicRecipesController = StreamController<List<Recipe>>.broadcast();
  final _userFollowingController = StreamController<List<UserData>>.broadcast();
  final _userFollowersController = StreamController<List<UserData>>.broadcast();
  final _allFavouritesController =
      StreamController<List<RecipeUserFavourite>>.broadcast();
  final _allFollowingController =
      StreamController<List<UserDataSocial>>.broadcast();
  final _allPagedRecipes = List<List<Recipe>>();
  final _allPagedFavourites = List<List<Recipe>>();
  final _allPagedCookbooks = List<List<Cookbook>>();
  final _allPublicPagedRecipes = List<List<Recipe>>();
  final _allPagedUserFollowing = List<List<UserData>>();
  final _allPagedUserFollowers = List<List<UserData>>();

  static const int pageLimit = 10;

  DocumentSnapshot _lastRecipe;
  DocumentSnapshot _lastCookbook;
  DocumentSnapshot _lastFavourite;
  DocumentSnapshot _lastFollowing;
  DocumentSnapshot _lastFollowers;
  DocumentSnapshot _lastPublicRecipe;
  bool _hasMoreRecipes = true;
  bool _hasMoreFollowing = true;
  bool _hasMoreFollowers = true;
  bool _hasMoreCookbooks = true;
  bool _hasMoreFavourites = true;
  bool _hasMorePublicRecipes = true;

  Stream<List<UserData>> listenToUserFollowingRealTime() {
    _requestUserFollowing();
    return _userFollowingController.stream;
  }

  Stream<List<UserData>> listenToUserFollowersRealTime() {
    _requestUserFollowers();
    return _userFollowersController.stream;
  }

  Stream<List<Recipe>> listenToRecipesRealTime({@required String cookbookId}) {
    _requestRecipes(cookbookId: cookbookId);
    return _recipesController.stream;
  }

  Stream<List<Recipe>> listenToFavouriteRecipesRealTime() {
    _requestFavourites();
    return _favouritesController.stream;
  }

  Stream<List<RecipeUserFavourite>> listenToAllFavouriteRecipesRealTime() {
    _requestAllFavourites();
    return _allFavouritesController.stream;
  }

  Stream<UserData> listenToUserDataRealTime() {
    _requestUserData();
    return _userDataController.stream;
  }

  Stream<UserData> listenToPublicUserDataRealTime(String publicUid) {
    // _requestPublicUserData(publicUid);
    // return _publicUserDataController.stream;
    final _userDataSnaphot = FirebaseFirestore.instance
        .collection('users')
        .doc(publicUid)
        .snapshots();

    return _userDataSnaphot.map(
      (snapshot) => UserData.fromMap(
        snapshot.data(),
        snapshot.id,
      ),
    );
  }

  Stream<List<UserDataSocial>> listenToAllUserFollowing() {
    _requestAllFollowing();
    return _allFollowingController.stream;
  }

  Stream<List<Recipe>> listenToPublicRecipesRealTime() {
    _requestPublicRecipes();
    return _publicRecipesController.stream;
  }

  Stream<List<Cookbook>> listenToCookbooksRealTime() {
    _requestCookbooks();
    return _cookbooksController.stream;
  }

  Stream<Recipe> listenToUserRecipeRealTime({@required String recipeId}) {
    _requestUserRecipe(recipeId);
    return _userRecipeController.stream;
  }

  Future<void> _requestUserData() async {
    final _userDataSnaphot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final userData = UserData.fromMap(
      _userDataSnaphot.data(),
      _userDataSnaphot.id,
    );

    _userDataController.add(userData);
  }

  Future<void> _requestAllFollowing() async {
    final _userFollowing = FirebaseFirestore.instance
        .collection('following')
        .doc(uid)
        .collection('users')
        .snapshots();

    _userFollowing.listen((snapshot) {
      List<UserDataSocial> userDataSocials = snapshot.docs
          .map((snapshot) =>
              UserDataSocial.fromMap(snapshot.data(), snapshot.id))
          .toList();
      _allFollowingController.add(userDataSocials);
    });
  }

  Future<void> _requestAllFavourites() async {
    final _userRecipesSnaphots = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        .snapshots();

    _userRecipesSnaphots.listen((snapshot) {
      // if (snapshot.docs.isNotEmpty) {
      List<RecipeUserFavourite> recipeFavourites = snapshot.docs
          .map((snapshot) =>
              RecipeUserFavourite.fromMap(snapshot.data(), snapshot.id))
          .toList();
      _allFavouritesController.add(recipeFavourites);
      // } else {
      //     _recipesController.addError('No Recipe Favourites Available');
      // }
    });
  }

  Future<void> _requestUserRecipe(String recipeId) async {
    final _recipeSnaphot = await FirebaseFirestore.instance
        .collection('recipes')
        .doc(recipeId)
        .get();

    final recipe = Recipe.fromMap(
      _recipeSnaphot.data(),
      _recipeSnaphot.id,
    );

    _userRecipeController.add(recipe);
  }

  // Future<void> _requestPublicUserData(String publicUid) async {
  //   final _userDataSnaphot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(publicUid)
  //       .get();

  //   final userData = UserData.fromMap(
  //     _userDataSnaphot.data(),
  //     _userDataSnaphot.id,
  //   );

  //   _publicUserDataController.add(userData);
  // }

  void _requestUserFollowing() {
    Query pageUserFollowingQuery = FirebaseFirestore.instance
        .collection('following')
        .doc(uid)
        .collection('users')
        .orderBy('firstName', descending: true)
        .limit(pageLimit);

    if (_lastFollowing != null) {
      pageUserFollowingQuery =
          pageUserFollowingQuery.startAfterDocument(_lastRecipe);
    }

    if (!_hasMoreFollowing) return;

    int currentRequestIndex = _allPagedUserFollowing.length;

    pageUserFollowingQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<UserData> generalFollowing = snapshot.docs
              .map((snapshot) => UserData.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPagedUserFollowing.length;

          if (pageExists) {
            _allPagedUserFollowing[currentRequestIndex] = generalFollowing;
          } else {
            _allPagedUserFollowing.add(generalFollowing);
          }

          var allFollowing = _allPagedUserFollowing.fold<List<UserData>>(
              List<UserData>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _userFollowingController.add(allFollowing);

          if (currentRequestIndex == _allPagedUserFollowing.length - 1) {
            _lastFollowing = snapshot.docs.last;
          }

          _hasMoreFollowing = generalFollowing.length == pageLimit;
        } else {
          _userFollowingController.addError('You are not following anyone');
        }
      },
    );
  }

  void _requestUserFollowers() {
    Query pageUserFollowersQuery = FirebaseFirestore.instance
        .collection('followers')
        .doc(uid)
        .collection('users')
        .orderBy('firstName', descending: true)
        .limit(pageLimit);

    if (_lastFollowers != null) {
      pageUserFollowersQuery =
          pageUserFollowersQuery.startAfterDocument(_lastFollowers);
    }

    if (!_hasMoreFollowers) return;

    int currentRequestIndex = _allPagedUserFollowers.length;

    pageUserFollowersQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<UserData> generalFollowers = snapshot.docs
              .map((snapshot) => UserData.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPagedUserFollowers.length;

          if (pageExists) {
            _allPagedUserFollowers[currentRequestIndex] = generalFollowers;
          } else {
            _allPagedUserFollowers.add(generalFollowers);
          }

          var allFollowers = _allPagedUserFollowers.fold<List<UserData>>(
              List<UserData>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _userFollowersController.add(allFollowers);

          if (currentRequestIndex == _allPagedUserFollowers.length - 1) {
            _lastFollowers = snapshot.docs.last;
          }

          _hasMoreFollowers = generalFollowers.length == pageLimit;
        } else {
          _userFollowersController.addError('You have no followers');
        }
      },
    );
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

  void _requestFavourites() {
    Query pageFavouriteQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favourites')
        // .orderBy('createdAt', descending: true) createdAt field doesn't exist
        .limit(pageLimit);

    if (_lastFavourite != null) {
      pageFavouriteQuery =
          pageFavouriteQuery.startAfterDocument(_lastFavourite);
    }

    if (!_hasMoreFavourites) return;

    int currentRequestIndex = _allPagedFavourites.length;

    pageFavouriteQuery.snapshots().listen(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) {
          List<Recipe> generalFavourites = snapshot.docs
              .map((snapshot) => Recipe.fromMap(snapshot.data(), snapshot.id))
              .toList();

          bool pageExists = currentRequestIndex < _allPagedFavourites.length;

          if (pageExists) {
            _allPagedFavourites[currentRequestIndex] = generalFavourites;
          } else {
            _allPagedFavourites.add(generalFavourites);
          }

          var allFavourites = _allPagedFavourites.fold<List<Recipe>>(
              List<Recipe>(),
              (previousValue, pageItems) => previousValue..addAll(pageItems));

          _favouritesController.add(allFavourites);

          if (currentRequestIndex == _allPagedFavourites.length - 1) {
            _lastFavourite = snapshot.docs.last;
          }

          _hasMoreFavourites = generalFavourites.length == pageLimit;
        } else {
          _favouritesController.addError('No Favourites Available');
        }
      },
    );
  }

  void requestMoreRecipes({@required String cookbookId}) =>
      _requestRecipes(cookbookId: cookbookId);

  void requestMoreCookbooks() => _requestCookbooks();

  void requestMoreFavourites() => _requestFavourites();

  void requestMoreFollowing() => _requestUserFollowing();

  void requestMoreFollowers() => _requestUserFollowers();

  void requestMorePublicRecipes() => _requestPublicRecipes();

  void closeRecipesController() => _recipesController.done;

  void closeUserDataController() => _userDataController.done;

  void closeCookbooksController() => _cookbooksController.done;

  void closeUserRecipeController() => _userRecipeController.done;

  void closeFavouritesController() => _favouritesController.done;

  void closeAllFollowingController() => _allFollowingController.done;

  void closePublicRecipesController() => _publicRecipesController.done;

  void closeAllFavouritesController() => _allFavouritesController.done;

  void closeUserFollowingController() => _userFollowingController.done;

  void closeUserFollowersController() => _userFollowersController.done;

  // void closePublicUserDataController() => _publicUserDataController.done;
}
