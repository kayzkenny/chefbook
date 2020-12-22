import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/recipes/recipe_stat_card.dart';
// import 'package:chefbook/services/cloud_functions_service.dart';

class UserRecipeDetailPage extends HookWidget {
  UserRecipeDetailPage({Key key}) : super(key: key);

  static const routeName = '/user-recipe-detail';
  @override
  Widget build(BuildContext context) {
    final String recipeId = ModalRoute.of(context).settings.arguments;
    final userRecipeStream = useProvider(userRecipeProvider(recipeId));

    return userRecipeStream.when(
      data: (userRecipe) => UserRecipeDetail(userRecipe: userRecipe),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}

class UserRecipeDetail extends HookWidget {
  UserRecipeDetail({@required this.userRecipe, Key key}) : super(key: key);

  final Recipe userRecipe;

  @override
  Widget build(BuildContext context) {
    final publicUserDataStream = useProvider(
      publicUserDataProvider(userRecipe.createdBy),
    );
    // final userData = useProvider(userDataProvider)?.data?.value;
    // final followLoading = useState(false);
    // final unfollowLoading = useState(false);
    // final likeLoading = useState(false);
    // final unlikeLoading = useState(false);

    Future<void> likeRecipe() async {
      // likeLoading.value = true;
      // await context
      //     .read(cloudFunctionsProvider)
      //     .likeRecipe(recipeId: userRecipe.id);
      // likeLoading.value = false;
    }

    Future<void> unlikeRecipe() async {
      // unlikeLoading.value = true;
      // await context
      //     .read(cloudFunctionsProvider)
      //     .unlikeRecipe(recipeId: userRecipe.id);
      // unlikeLoading.value = false;
    }

    Future<void> followUser() async {
      // followLoading.value = true;
      // await context
      //     .read(cloudFunctionsProvider)
      //     .followUser(uid: publicUserData.uid);
      // followLoading.value = false;
    }

    Future<void> unfollowUser() async {
      // unfollowLoading.value = true;
      // await context
      //     .read(cloudFunctionsProvider)
      //     .unfollowUser(uid: publicUserData.uid);
      // unfollowLoading.value = false;
    }

    return publicUserDataStream.when(
      data: (publicUserData) => Scaffold(
        body: CustomScrollView(
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
                        // IconButton(
                        //   icon: Icon(Icons.share),
                        //   onPressed: () {},
                        // ),
                        // if (userData != null)
                        //   userData.favourites.contains(userRecipe.id)
                        //       ? IconButton(
                        //           icon: unlikeLoading.value == false
                        //               ? Icon(
                        //                   Icons.favorite_border,
                        //                   color: Colors.red,
                        //                 )
                        //               : CircularProgressIndicator(
                        //                   strokeWidth: 2.0,
                        //                 ),
                        //           onPressed: unlikeLoading.value == false
                        //               ? unlikeRecipe
                        //               : () {},
                        //         )
                        //       : IconButton(
                        //           icon: likeLoading.value == false
                        //               ? Icon(
                        //                   Icons.favorite,
                        //                   color: Colors.red,
                        //                 )
                        //               : CircularProgressIndicator(
                        //                   strokeWidth: 2.0,
                        //                 ),
                        //           onPressed: likeLoading.value == false
                        //               ? likeRecipe
                        //               : () {},
                        //         ),
                        // Text(
                        //   '${userRecipe.likesCount}',
                        //   style: Theme.of(context).textTheme.headline6,
                        // ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    // if (publicUserData != null && userData != null)
                    Row(
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
                        // if (!userData.following
                        //         .contains(publicUserData.uid) &&
                        //     publicUserData.uid != userData.uid)
                        //   OutlineButton(
                        //     onPressed: followLoading.value == false
                        //         ? followUser
                        //         : () {},
                        //     child: followLoading.value == false
                        //         ? Text(
                        //             'Follow',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .button,
                        //           )
                        //         : CircularProgressIndicator(
                        //             strokeWidth: 2.0,
                        //           ),
                        //   ),
                        // if (userData.following
                        //         .contains(publicUserData.uid) &&
                        //     publicUserData.uid != userData.uid)
                        //   OutlineButton(
                        //     onPressed: followLoading.value == false
                        //         ? unfollowUser
                        //         : () {},
                        //     child: followLoading.value == false
                        //         ? Text(
                        //             'UnFollow',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .button,
                        //           )
                        //         : CircularProgressIndicator(
                        //             strokeWidth: 2.0,
                        //           ),
                        //   )
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      elevation: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              label: '${userRecipe.caloriesPerServing} cal',
                              icon: Icons.whatshot,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('data'),
                    SizedBox(height: 16.0),
                    Text(
                      'Tags',
                      style: Theme.of(context).textTheme.headline6,
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
                      style: Theme.of(context).textTheme.headline6,
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
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 16.0),
                    if (userRecipe.steps.length > 0)
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
