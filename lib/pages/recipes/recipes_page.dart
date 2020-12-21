import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/recipes/recipe_card.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/pages/recipes/recipe_detail_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class RecipesPage extends HookWidget {
  const RecipesPage({Key key}) : super(key: key);

  static const routeName = '/my-recipes';
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final Cookbook cookbook = ModalRoute.of(context).settings.arguments;
    final recipesStream = useProvider(recipesProvider(cookbook.id));

    void resetFormState() {
      context.read(tagsNotifierProvider).resetTags();
      context.read(stepsNotifierProvider).resetSteps();
      context.read(recipeNotifierProvider).resetIntro();
      context.read(ingredientsNotifierProvider).resetIngredients();
    }

    Future<void> showRecipeForm() async {
      resetFormState();

      await Navigator.pushNamed(
        context,
        RecipeForm.routeName,
        arguments: cookbook.id,
      );
    }

    getMoreRecipes() {
      context
          .read(firestoreRepositoryProvider)
          .requestMoreRecipes(cookbookId: cookbook.id);
    }

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          getMoreRecipes();
        }
      });
      return () => scrollController.removeListener(() {});
    }, [scrollController]);

    return recipesStream.when(
      data: (recipeList) => Scaffold(
        appBar: AppBar(
          title: Text(
            'My Recipes',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SafeArea(
          child: recipeList.length == 0
              ? Center(
                  child: Text('No Recipes to Show'),
                )
              : ListView.builder(
                  itemCount: recipeList.length,
                  controller: scrollController,
                  padding: EdgeInsets.all(20.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final recipe = recipeList[index];
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pushNamed(
                          context,
                          RecipeDetailPage.routeName,
                          arguments: recipe.id,
                        );
                      },
                      child: RecipeCard(recipe: recipe),
                    );
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: showRecipeForm,
          child: Icon(FeatherIcons.plus),
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
