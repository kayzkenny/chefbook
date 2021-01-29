import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/pages/recipes/new_ing_dialog.dart';
import 'package:chefbook/pages/recipes/edit_ing_dialog.dart';

class RecipeIngredientsForm extends ConsumerWidget {
  const RecipeIngredientsForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final ingredientsNotifierState = watch(ingredientsNotifierProvider.state);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomFlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewIngredientDialog(),
                  fullscreenDialog: true,
                ),
              );
            },
            label: Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ingredientsNotifierState.length == 0
            ? Center(
                child: Text('No Ingredients to Show'),
              )
            : Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                  itemCount: ingredientsNotifierState.length,
                  itemBuilder: (BuildContext context, index) {
                    final ingredient = ingredientsNotifierState[index];
                    return Dismissible(
                      key: Key(ingredient),
                      onDismissed: (direction) {
                        context
                            .read(ingredientsNotifierProvider)
                            .deleteIngredient(ingredient);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditIngredientDialog(
                                ingredient: ingredient,
                                ingredientIndex: index,
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(ingredientsNotifierState[index]),
                        ),
                      ),
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
