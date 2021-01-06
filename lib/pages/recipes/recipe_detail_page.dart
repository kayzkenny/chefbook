import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/recipe_repo.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/recipes/recipe_stat_card.dart';
import 'package:chefbook/pages/recipes/recipe_image_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class RecipeDetailPage extends ConsumerWidget {
  RecipeDetailPage({Key key}) : super(key: key);

  static const routeName = '/recipe-detail';

  final userRecipeProvider = StreamProvider.family<Recipe, String>(
    (ref, recipeId) => FirestoreDatabase(
      uid: ref.watch(authProvider).currentUser().uid,
    ).recipeStream(recipeId: recipeId),
  );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final String recipeId = ModalRoute.of(context).settings.arguments;
    final userRecipeStream = watch(userRecipeProvider(recipeId));

    return userRecipeStream.when(
      data: (userRecipe) => RecipeDetail(userRecipe: userRecipe),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}

class RecipeDetail extends HookWidget {
  const RecipeDetail({this.userRecipe, Key key}) : super(key: key);

  final Recipe userRecipe;

  @override
  Widget build(BuildContext context) {
    final loadingDeleteRecipe = useState(false);

    void _showRecipeImagePicker() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            RecipeImagePicker(recipe: userRecipe),
      );
    }

    Future<void> deleteRecipe() async {
      final bool result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Recipe'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this recipe?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('DELETE'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (result == true) {
        loadingDeleteRecipe.value = true;
        await context
            .read(databaseProvider)
            .deleteRecipe(recipeId: userRecipe.id);
        loadingDeleteRecipe.value = false;
        Navigator.of(context).pop(true);
      } else {
        print("Canceled Pressed");
      }
    }

    return DefaultTabController(
      length: 3,
      child: userRecipe ==
              null // just deleted this recipe don't build this page
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(
                  'Recipe',
                  style: Theme.of(context).textTheme.headline5,
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.brown,
                    ),
                    onPressed: loadingDeleteRecipe.value ? () {} : deleteRecipe,
                  )
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
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Name',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              userRecipe.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(height: 40.0),
                            Card(
                              elevation: 3.0,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RecipeStat(
                                      label: 'Serves ${userRecipe.serves}',
                                      icon: Icons.kitchen,
                                    ),
                                    RecipeStat(
                                      label: '${userRecipe.duration} minutes',
                                      icon: Icons.timer,
                                    ),
                                    RecipeStat(
                                      label:
                                          '${userRecipe.caloriesPerServing} cal',
                                      icon: Icons.whatshot,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                            SizedBox(
                              height: 200.0,
                              child: userRecipe.imageURL == null
                                  ? Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          child: Image.asset(
                                            'images/logo.jpg',
                                            height: 200.0,
                                            // width: 300.0,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.brown,
                                            ),
                                            child: IconButton(
                                              icon: Icon(FeatherIcons.edit2),
                                              color: Colors.white,
                                              onPressed: _showRecipeImagePicker,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          child: Image.network(
                                            userRecipe.imageURL,
                                            height: 200.0,
                                            // width: 300.0,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.brown,
                                            ),
                                            child: IconButton(
                                              icon: Icon(FeatherIcons.edit2),
                                              color: Colors.white,
                                              onPressed: _showRecipeImagePicker,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                            SizedBox(height: 40.0),
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              userRecipe.description,
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 8,
                            ),
                            SizedBox(height: 40.0),
                            Text(
                              'Tags',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            SizedBox(height: 10.0),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              direction: Axis.horizontal,
                              children: List.generate(
                                userRecipe.tags.length,
                                (index) {
                                  final tag = userRecipe.tags[index];
                                  return userRecipe.tags.length == 0
                                      ? Center(child: Text('No Tags to Show'))
                                      : Chip(label: Text(tag));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      userRecipe.ingredients.length == 0
                          ? Center(
                              child: Text('No Ingredients to Show'),
                            )
                          : ListView.separated(
                              itemCount: userRecipe.ingredients.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                title: Text(
                                  userRecipe.ingredients[index],
                                ),
                              ),
                            ),
                      userRecipe.steps.length == 0
                          ? Center(
                              child: Text('No Steps to Show'),
                            )
                          : ListView.separated(
                              itemCount: userRecipe.steps.length,
                              separatorBuilder: (context, index) => Divider(),
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                title: Text(
                                  userRecipe.steps[index],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  context.read(tagsNotifierProvider).addTags(userRecipe.tags);
                  context
                      .read(stepsNotifierProvider)
                      .addSteps(userRecipe.steps);
                  context
                      .read(ingredientsNotifierProvider)
                      .addIngredients(userRecipe.ingredients);
                  context.read(recipeNotifierProvider).updateIntro(
                        IntroStateModel(
                          name: userRecipe.name,
                          serves: userRecipe.serves,
                          duration: userRecipe.duration,
                          description: userRecipe.description,
                          caloriesPerServing: userRecipe.caloriesPerServing,
                        ),
                      );
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeForm(
                        recipeId: userRecipe.id,
                      ),
                    ),
                  );
                },
                child: Icon(FeatherIcons.edit),
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
              ),
            ),
    );
  }
}
