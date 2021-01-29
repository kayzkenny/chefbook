import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/sign_in/sign_in.dart';
import 'package:chefbook/pages/sign_in/register.dart';

class Authenticate extends HookWidget {
  Authenticate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabKey = GlobalKey();
    final tabIndex = useState(0);
    final tabController = useTabController(initialLength: 2);

    tabController.addListener(() => tabIndex.value = tabController.index);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/logo.png',
          height: 50.0,
          width: 50.0,
        ),
        bottom: TabBar(
          onTap: (index) {},
          controller: tabController,
          indicatorColor: Theme.of(context).accentColor,
          tabs: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              'Create Account',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
      body: TabBarView(
        key: tabKey,
        controller: tabController,
        children: [
          SignInPage(),
          RegisterPage(),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
