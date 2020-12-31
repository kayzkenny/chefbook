import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/search/search_page.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/feed/user_recipe_card.dart';
import 'package:chefbook/pages/feed/user_recipe_detail_page.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recipes',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, SearchPage.routeName),
          )
        ],
      ),
      body: SafeArea(
        child: puiblicRecipesStream.when(
          data: (publicRecipeList) => ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(20.0),
            itemCount: publicRecipeList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final publicRecipe = publicRecipeList[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(
                    context,
                    UserRecipeDetailPage.routeName,
                    arguments: publicRecipe.id,
                  );
                },
                child: UserRecipeCard(userRecipe: publicRecipe),
              );
            },
          ),
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('${error.toString()}'),
          ),
        ),
      ),
    );
  }
}
