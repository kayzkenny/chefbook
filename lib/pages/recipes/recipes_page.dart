import 'package:chefbook/repository/firestore_repo.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipe_card.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/recipes/recipe_detail_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:chefbook/pages/cookbook/edit_cookbook.dialog.dart';
import 'package:chefbook/pages/cookbook/cookbook_cover_picker.dart';

// enum CookbookAction { rename, editBookCover, delete }

// class RecipesPage extends HookWidget {
//   const RecipesPage({Key key}) : super(key: key);

//   static const routeName = '/my-recipes';

//   @override
//   Widget build(BuildContext context) {
//     final recipes = useState(<Recipe>[]);
//     final gettingMoreRecipes = useState(false);
//     final loadingFirstRecipes = useState(false);
//     final moreRecipesAvaliable = useState(true);
//     final scrollController = useScrollController();
//     final Cookbook cookbook = ModalRoute.of(context).settings.arguments;

//     Future<void> getFirstRecipes() async {
//       loadingFirstRecipes.value = true;
//       List<Recipe> firstRecipes = await context
//           .read(databaseProvider)
//           .getFirstRecipesByCookbookId(cookbookId: cookbook.id);
//       if (firstRecipes.length < 10) {
//         moreRecipesAvaliable.value = false;
//       }
//       recipes.value = firstRecipes;
//       loadingFirstRecipes.value = false;
//     }

//     Future<void> getMoreRecipes() async {
//       if (moreRecipesAvaliable.value == false) {
//         return;
//       } else if (gettingMoreRecipes.value == true) {
//         return;
//       }

//       gettingMoreRecipes.value = true;

//       List<Recipe> moreRecipes = await context
//           .read(databaseProvider)
//           .getMoreRecipesByCookbookId(cookbookId: cookbook.id);

//       if (moreRecipes.length < 10) {
//         moreRecipesAvaliable.value = false;
//       } else if (moreRecipes.length != 0) {
//         recipes.value.addAll(moreRecipes);
//       }

//       gettingMoreRecipes.value = false;
//     }

//     void _showEditCookbookForm() {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => EditCookbookDialog(cookbook: cookbook),
//       );
//     }

//     void _showCookbookCoverPicker() {
//       showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) =>
//             CookBookCoverPicker(cookbook: cookbook),
//       );
//     }

//     Future<void> deleteCookbook() async {
//       final bool result = await showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Delete Cookbook'),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[
//                   Text('Are you sure you want to delte this recipe?'),
//                   Text(
//                     'All recipes associated with this cookbook will also be deleted',
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('CANCEL'),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               FlatButton(
//                 child: Text('DELETE'),
//                 onPressed: () {
//                   context
//                       .read(databaseProvider)
//                       .deleteCookbook(cookbookId: cookbook.id);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );

//       if (result == true) {
//         context.read(databaseProvider).deleteCookbook(cookbookId: cookbook.id);
//       } else {
//         print("Canceled Pressed");
//       }
//     }

//     void resetFormState() {
//       context.read(tagsNotifierProvider).resetTags();
//       context.read(stepsNotifierProvider).resetSteps();
//       context.read(recipeNotifierProvider).resetIntro();
//       context.read(ingredientsNotifierProvider).resetIngredients();
//     }

//     Future<void> showRecipeForm() async {
//       resetFormState();

//       final result = await Navigator.pushNamed(
//         context,
//         RecipeForm.routeName,
//         arguments: cookbook.id,
//       );

//       if (result == true) {
//         await getFirstRecipes();
//       }
//     }

//     useEffect(() {
//       getFirstRecipes();
//       scrollController.addListener(() {
//         double currentScroll = scrollController.position.pixels;
//         double maxScroll = scrollController.position.maxScrollExtent;
//         double delta = MediaQuery.of(context).size.height * 0.25;

//         if (maxScroll - currentScroll < delta) {
//           // if (recipes.value.length < 10) {
//           getMoreRecipes();
//           // }
//         }
//       });
//       return () => scrollController.removeListener(() {});
//     }, [scrollController]);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'My Recipes',
//           style: Theme.of(context).textTheme.headline5,
//         ),
//         actions: [
//           PopupMenuButton<CookbookAction>(
//             onSelected: (CookbookAction action) async {
//               switch (action) {
//                 case CookbookAction.rename:
//                   _showEditCookbookForm();
//                   break;
//                 case CookbookAction.editBookCover:
//                   _showCookbookCoverPicker();
//                   break;
//                 case CookbookAction.delete:
//                   await deleteCookbook();
//                   Navigator.pop(context);
//                   break;
//                 default:
//               }
//             },
//             itemBuilder: (BuildContext context) =>
//                 <PopupMenuEntry<CookbookAction>>[
//               PopupMenuItem<CookbookAction>(
//                 value: CookbookAction.rename,
//                 child: Text(
//                   'Rename',
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//               ),
//               PopupMenuItem<CookbookAction>(
//                 value: CookbookAction.editBookCover,
//                 child: Text(
//                   'Edit Book Cover',
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//               ),
//               PopupMenuItem<CookbookAction>(
//                 value: CookbookAction.delete,
//                 child: Text(
//                   'Delete Cookbook',
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: loadingFirstRecipes.value == true
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : recipes.value.length == 0
//                 ? Center(
//                     child: Text('No Recipes To Show'),
//                   )
//                 : RefreshIndicator(
//                     onRefresh: () async => recipes.value = await context
//                         .read(databaseProvider)
//                         .getFirstRecipesByCookbookId(cookbookId: cookbook.id),
//                     child: ListView.builder(
//                       controller: scrollController,
//                       padding: EdgeInsets.all(20.0),
//                       itemCount: recipes.value.length,
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       itemBuilder: (BuildContext context, int index) {
//                         final recipe = recipes.value[index];
//                         return GestureDetector(
//                           onTap: () async {
//                             Navigator.pushNamed(
//                               context,
//                               RecipeDetailPage.routeName,
//                               arguments: recipe.id,
//                             );
//                             // getFirstRecipes();
//                           },
//                           child: RecipeCard(
//                             recipe: recipes.value[index],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showRecipeForm,
//         child: Icon(FeatherIcons.plus),
//         backgroundColor:
//             Theme.of(context).floatingActionButtonTheme.backgroundColor,
//       ),
//     );
//   }
// }

class RecipesPage extends HookWidget {
  const RecipesPage({Key key}) : super(key: key);

  static const routeName = '/my-recipes';
  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final Cookbook cookbook = ModalRoute.of(context).settings.arguments;
    final recipesStream = useProvider(recipesProvider(cookbook.id));

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final snackBar = SnackBar(
      content: Text('No More Recipes'),
      backgroundColor: Colors.brown[700],
    );

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
          child: ListView.builder(
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
