import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';

class PublicUserProfilePage extends HookWidget {
  PublicUserProfilePage({Key key}) : super(key: key);

  static const routeName = '/publicuserprofile';

  @override
  Widget build(BuildContext context) {
    final String publicUid = ModalRoute.of(context).settings.arguments;
    final publicUserDataStream = useProvider(publicUserDataProvider(publicUid));

    return publicUserDataStream.when(
      data: (publicUserData) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      height: 200.0,
                      child: publicUserData.avatar != null
                          ? CircleAvatar(
                              radius: 100.0,
                              backgroundImage:
                                  NetworkImage(publicUserData.avatar),
                            )
                          : CircleAvatar(
                              radius: 100.0,
                              backgroundColor: Colors.brown,
                              child: publicUserData.firstName == null
                                  ? Text(
                                      'N/A',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(color: Colors.white),
                                    )
                                  : Text(
                                      '${publicUserData.firstName.substring(0, 1)} ${publicUserData.lastName.substring(0, 1)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(color: Colors.white),
                                    ),
                            ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Center(
                    child: Text(
                      '${publicUserData.firstName} ${publicUserData.lastName}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  SizedBox(height: 40.0),
                  ListTile(
                    // leading: Icon(Icons.share),
                    title: Text(
                      'Recipes',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: Text('${publicUserData.recipeCount}'),
                  ),
                  Divider(),
                  ListTile(
                    // leading: Icon(Icons.share),
                    title: Text(
                      'Followers',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: Text('${publicUserData.followerCount}'),
                  ),
                  Divider(),
                  ListTile(
                    // leading: Icon(Icons.share),
                    title: Text(
                      'Following',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    trailing: Text('${publicUserData.followingCount}'),
                  ),
                  SizedBox(height: 40.0),
                  CustomFlatButton(
                    onPressed: () {},
                    label: Text('Follow'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
