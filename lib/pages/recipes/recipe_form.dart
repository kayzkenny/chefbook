import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/recipe_repo.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/recipes/recipe_ing_form.dart';
import 'package:chefbook/pages/recipes/recipe_intro_form.dart';
import 'package:chefbook/pages/recipes/recipe_steps_form.dart';

final stepsNotifierProvider = StateNotifierProvider<StepsNotifier>(
  (ref) => StepsNotifier(),
);

final ingredientsNotifierProvider = StateNotifierProvider<IngredientsNotifier>(
  (ref) => IngredientsNotifier(),
);

final tagsNotifierProvider = StateNotifierProvider<TagsNotifier>(
  (ref) => TagsNotifier(),
);

final recipeNotifierProvider = StateNotifierProvider<RecipeNotifier>(
  (ref) => RecipeNotifier(
    IntroStateModel(),
  ),
);

class RecipeForm extends HookWidget {
  RecipeForm({this.recipeId, Key key}) : super(key: key);

  final String recipeId;

  static const routeName = '/recipeForm';

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(authProvider);
    final loadingCreateRecipe = useState(false);
    final loadingUpdateRecipe = useState(false);
    final tags = useProvider(tagsNotifierProvider.state);
    final steps = useProvider(stepsNotifierProvider.state);
    final recipeIntro = useProvider(recipeNotifierProvider.state);
    final ingredients = useProvider(ingredientsNotifierProvider.state);
    final String cookbookId = ModalRoute.of(context).settings.arguments;

    Future<void> createRecipe() async {
      final recipe = Recipe(
        tags: tags,
        steps: steps,
        cookbookId: cookbookId,
        name: recipeIntro.name,
        ingredients: ingredients,
        createdAt: DateTime.now(),
        serves: recipeIntro.serves,
        lastUpdated: DateTime.now(),
        duration: recipeIntro.duration,
        createdBy: auth.currentUser().uid,
        description: recipeIntro.description,
        caloriesPerServing: recipeIntro.caloriesPerServing,
      );
      loadingCreateRecipe.value = true;
      await context.read(databaseProvider).createRecipe(recipe: recipe);
      loadingCreateRecipe.value = false;
    }

    Future<void> updateRecipe() async {
      final recipe = Recipe(
        tags: tags,
        steps: steps,
        id: recipeId,
        name: recipeIntro.name,
        ingredients: ingredients,
        serves: recipeIntro.serves,
        lastUpdated: DateTime.now(),
        duration: recipeIntro.duration,
        createdBy: auth.currentUser().uid,
        description: recipeIntro.description,
        caloriesPerServing: recipeIntro.caloriesPerServing,
      );
      loadingUpdateRecipe.value = true;
      await context.read(databaseProvider).updateRecipe(recipe: recipe);
      loadingUpdateRecipe.value = false;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'RecipeForm',
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: [
            recipeId != null
                ? FlatButton(
                    onPressed: loadingUpdateRecipe.value
                        ? () {}
                        : () async {
                            await updateRecipe();
                            Navigator.of(context).pop(true);
                          },
                    child: Text(
                      'UPDATE',
                      style: Theme.of(context).textTheme.button,
                    ),
                  )
                : FlatButton(
                    onPressed: loadingCreateRecipe.value
                        ? () {}
                        : () async {
                            await createRecipe();
                            Navigator.of(context).pop(true);
                          },
                    child: Text(
                      'SAVE',
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'INTRO',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Tab(
                child: Text(
                  'INGREDIENTS',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
              Tab(
                child: Text(
                  'STEPS',
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: TabBarView(
              children: [
                RecipeIntroForm(),
                RecipeIngredientsForm(),
                RecipeStepsForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
