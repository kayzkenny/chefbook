import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/feed/user_recipe_card.dart';
import 'package:chefbook/pages/feed/user_recipe_detail_page.dart';

class FavouritesPage extends HookWidget {
  const FavouritesPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final favouriteRecipesStream =
        useProvider(paginatedFavouriteRecipesProvider);

    getMoreFavourites() =>
        context.read(firestoreRepositoryProvider).requestMoreFavourites();

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          getMoreFavourites();
        }
      });
      return () => scrollController.removeListener(() {});
    }, [scrollController]);

    return favouriteRecipesStream.when(
      data: (favouriteRecipeList) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Favourite Recipes',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SafeArea(
          child: ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(20.0),
            itemCount: favouriteRecipeList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final favouriteRecipe = favouriteRecipeList[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    UserRecipeDetailPage.routeName,
                    arguments: favouriteRecipe.id,
                  );
                },
                child: UserRecipeCard(userRecipe: favouriteRecipe),
              );
            },
          ),
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('${error.toString()}')),
    );
  }
}
