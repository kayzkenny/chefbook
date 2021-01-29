import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({this.recipe, Key key}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (recipe.imageURL != null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.network(
                recipe.imageURL,
                height: 200.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          if (recipe.imageURL == null)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Image.asset(
                'images/logo.jpg',
                height: 200.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          if (recipe.name != null)
            Padding(
              padding:
                  const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
              child: Text(
                recipe.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 20.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '${recipe.duration} mins',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.whatshot,
                      size: 20.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      '${recipe.caloriesPerServing} cal',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 20.0,
                    ),
                    SizedBox(width: 5.0),
                    Text(
                      'Serves: ${recipe.serves}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
