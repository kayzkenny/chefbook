import 'package:flutter/material.dart';
import 'package:chefbook/services/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/account/network_page.dart';
import 'package:chefbook/pages/account/profile_page.dart';

class AccountPage extends HookWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async => await context.read(authProvider).signOut();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          FlatButton(
            onPressed: signOut,
            child: Text('Logout'),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  ProfilePage.routeName,
                ),
                leading: Icon(Icons.account_circle),
                title: Text(
                  'My Profile',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
              Divider(),
              ListTile(
                onTap: () => Navigator.pushNamed(
                  context,
                  NetworkPage.routeName,
                  // arguments: userData,
                ),
                leading: Icon(Icons.people),
                title: Text(
                  'My Network',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.stars),
                title: Text(
                  'Rate Us',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(
                  'Share App',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
