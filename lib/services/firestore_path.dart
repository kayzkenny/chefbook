class FirestorePath {
  static String users() => 'users';
  static String recipes() => 'recipes';
  static String cuisines() => 'cuisines';
  static String cookbooks() => 'cookbooks';
  static String categories() => 'categories';
  static String userData(String uid) => 'users/$uid';
  static String userRecipe(String recipeId) => 'recipes/$recipeId';
  static String userFavourites(String uid) => 'users/$uid/favourites';
  static String userCookbook(String cookbookID) => 'cookbooks/$cookbookID';
  static String recipeUserRating(String recipeId, String uid) =>
      'recipes/$recipeId/ratings/$uid';
}
