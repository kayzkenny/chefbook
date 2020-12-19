import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';

class CookbookCard extends StatelessWidget {
  const CookbookCard({Key key, this.cookbook}) : super(key: key);

  final Cookbook cookbook;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cookbook.coverURL != null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.network(
                cookbook.coverURL,
                height: 200.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          if (cookbook.coverURL == null)
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset(
                'images/logo-jpg.jpg',
                height: 200.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cookbook.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '${cookbook.recipeCount} Recipes',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ],
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
