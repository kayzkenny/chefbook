import 'dart:io';

import 'package:chefbook/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/services/firestore_database.dart';

class PublicUserProfilePage extends HookWidget {
  PublicUserProfilePage({Key key}) : super(key: key);

  static const routeName = '/publicuserprofile';

  @override
  Widget build(BuildContext context) {
    final loadingFollowUser = useState(false);
    final loadingUnfollowUser = useState(false);
    final String puid = ModalRoute.of(context).settings.arguments;
    final followingStream = useProvider(allFollowingProvider);
    final currentUser = useProvider(authProvider).currentUser();
    final publicUserDataStream = useProvider(publicUserDataProvider(puid));

    void _showErrorDialog({String title, String content}) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> followUser(UserData userData) async {
      loadingFollowUser.value = true;
      try {
        await context.read(databaseProvider).followUser(userData: userData);
      } on SocketException catch (e) {
        _showErrorDialog(title: "Request Timed Out", content: e.message);
      } catch (e) {
        _showErrorDialog(
          title: "Something went wrong",
          content: "Please try again later",
        );
      } finally {
        loadingFollowUser.value = false;
      }
    }

    Future<void> unfollowUser(String publicUID) async {
      loadingUnfollowUser.value = true;
      try {
        await context.read(databaseProvider).unfollowUser(publicUID: publicUID);
      } on SocketException catch (e) {
        _showErrorDialog(title: "Request Timed Out", content: e.message);
      } catch (e) {
        _showErrorDialog(
          title: "Something went wrong",
          content: "Please try again later",
        );
      } finally {
        loadingUnfollowUser.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: publicUserDataStream.when(
              data: (publicUserData) => Column(
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
                  followingStream.when(
                    data: (followingList) {
                      final followedUser = followingList.firstWhere(
                          (followed) => followed.uid == publicUserData.uid,
                          orElse: () => null);
                      if (followedUser == null) {
                        return publicUserData.uid == currentUser.uid
                            ? SizedBox(height: 0.0,)
                            : CustomFlatButton(
                                onPressed: loadingFollowUser.value
                                    ? () {}
                                    : () => followUser(publicUserData),
                                label: loadingFollowUser.value
                                    ? const CircularProgressIndicator()
                                    : const Text('Follow'),
                              );
                      } else {
                        return CustomFlatButton(
                          onPressed: loadingUnfollowUser.value
                              ? () {}
                              : () => unfollowUser(publicUserData.uid),
                          label: loadingUnfollowUser.value
                              ? const CircularProgressIndicator()
                              : const Text('UnFollow'),
                        );
                      }
                    },
                    loading: () => Center(
                      child: const CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: const Text('Something went wrong'),
                    ),
                  ),
                ],
              ),
              loading: () => Center(
                child: const CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: const Text('Something went wrong'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
