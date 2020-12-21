import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';

class UserRecipeCard extends HookWidget {
  const UserRecipeCard({this.userRecipe, Key key}) : super(key: key);

  final Recipe userRecipe;

  @override
  Widget build(BuildContext context) {
    final userData = useProvider(publicUserDataProvider(userRecipe.createdBy));

    return Container(
      height: 110,
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Hero(
            tag: userRecipe.id,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: userRecipe.imageURL == null
                  ? Image.asset(
                      'images/logo.jpg',
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      userRecipe.imageURL,
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    userRecipe.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  if (userData.data != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: userData.data.value.avatar == null
                              ? AssetImage('images/logo-jpg.jpg')
                              : NetworkImage(userData.data.value.avatar),
                        ),
                        SizedBox(width: 20.0),
                        Flexible(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${userData.data.value.firstName} ${userData.data.value.lastName}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                Text(
                                  DateFormat.MMMEd()
                                      .format(userRecipe.lastUpdated),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
