import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/feed/user_recipe_card.dart';

class FeedPage extends HookWidget {
  const FeedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final puiblicRecipesStream = useProvider(publicRecipesProvider);

    getMorePublicRecipes() =>
        context.read(firestoreRepositoryProvider).requestMorePublicRecipes();

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          getMorePublicRecipes();
        }
      });
      return () => scrollController.removeListener(() {});
    }, [scrollController]);

    return puiblicRecipesStream.when(
      data: (publicRecipeList) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Recipes',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SafeArea(
          child: publicRecipeList.isEmpty
              ? Center(
                  child: Text('No Recipes to Show'),
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(20.0),
                  itemCount: publicRecipeList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final publicRecipe = publicRecipeList[index];
                    return GestureDetector(
                      onTap: () async {
                        // await Navigator.pushNamed(
                        //   context,
                        //   RecipesPage.routeName,
                        //   arguments: cookbook,
                        // );
                      },
                      child: UserRecipeCard(
                        userRecipe: publicRecipe,
                      ),
                    );
                  },
                ),
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
