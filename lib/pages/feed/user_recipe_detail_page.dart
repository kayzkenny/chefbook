import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/recipes/recipe_stat_card.dart';
import 'package:chefbook/pages/account/public_user_profile_page.dart';

class UserRecipeDetailPage extends HookWidget {
  UserRecipeDetailPage({Key key}) : super(key: key);

  static const routeName = '/user-recipe-detail';
  @override
  Widget build(BuildContext context) {
    final String recipeId = ModalRoute.of(context).settings.arguments;
    final userRecipeStream = useProvider(favouriteRecipeProvider(recipeId));

    return userRecipeStream.when(
      data: (userRecipe) => UserRecipeDetail(
        userRecipe: userRecipe.recipe,
        isFavourite: userRecipe.isFavourite,
      ),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: const Text('Something went wrong'),
        ),
      ),
    );
  }
}

class UserRecipeDetail extends HookWidget {
  UserRecipeDetail({
    @required this.userRecipe,
    @required this.isFavourite,
    Key key,
  }) : super(key: key);

  final Recipe userRecipe;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    final publicUserDataStream = useProvider(
      publicUserDataProvider(userRecipe.createdBy),
    );

    Future<void> addRecipeToFavourites(Recipe recipe) async => await context
        .read(databaseProvider)
        .addRecipeToFavourites(recipe: recipe);

    Future<void> removeRecipeFromFavourites(String recipeId) async =>
        await context
            .read(databaseProvider)
            .removeRecipeFromFavourites(recipeId: recipeId);

    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                  // title: Text(userRecipe.name),
                  background: Hero(
                    tag: userRecipe.id,
                    child: userRecipe.imageURL == null
                        ? Image.asset(
                            'images/logo.jpg',
                            fit: BoxFit.fitWidth,
                          )
                        : Image.network(
                            userRecipe.imageURL,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(32.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              userRecipe.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          isFavourite
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => removeRecipeFromFavourites(
                                    userRecipe.id,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      addRecipeToFavourites(userRecipe),
                                ),
                          Text(
                            '${userRecipe.favouritesCount}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.green,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      publicUserDataStream.when(
                        data: (publicUserData) => GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            PublicUserProfilePage.routeName,
                            arguments: publicUserData.uid,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 32.0,
                                backgroundImage: publicUserData.avatar != null
                                    ? NetworkImage(publicUserData.avatar)
                                    : AssetImage('images/logo.jpg'),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  '${publicUserData.firstName} ${publicUserData.lastName}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading: () => Center(
                          child: const CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Center(
                          child: const Text('Something went wrong'),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 100.0,
                        margin: EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            RecipeStat(
                              label: 'Serves ${userRecipe.serves}',
                              icon: Icons.kitchen,
                            ),
                            VerticalDivider(),
                            RecipeStat(
                              label: '${userRecipe.duration} minutes',
                              icon: Icons.timer,
                            ),
                            VerticalDivider(),
                            RecipeStat(
                              label: '${userRecipe.caloriesPerServing} cal',
                              icon: Icons.whatshot,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Tags',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 16.0),
                      if (userRecipe.tags.isNotEmpty)
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
                      SizedBox(height: 16.0),
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 16.0),
                      if (userRecipe.ingredients.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userRecipe.ingredients.length,
                          separatorBuilder: (context, index) => Divider(),
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            title: Text(
                              userRecipe.ingredients[index],
                            ),
                          ),
                        ),
                      SizedBox(height: 16.0),
                      Text(
                        'Steps',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      SizedBox(height: 16.0),
                      if (userRecipe.steps.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userRecipe.steps.length,
                          separatorBuilder: (context, index) => Divider(
                            indent: 40.0,
                          ),
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            title: Text(
                              userRecipe.steps[index],
                            ),
                          ),
                        ),
                      SizedBox(height: 60.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: Container(
              height: 60.0,
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${userRecipe.reviewCount} Reviews',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    'Stars',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
