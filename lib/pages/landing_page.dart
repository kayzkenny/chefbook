import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/pages/home/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/sign_in/authenticate.dart';

final userProvider =
    StreamProvider.autoDispose<User>((ref) => Auth().onAuthStateChanged);

class LandingPage extends ConsumerWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userStream = watch(userProvider);

    return userStream.when(
      data: (user) => user == null ? Authenticate() : HomePage(),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: const Text('Something went wrong'),
        ),
      ),
    );
  }
}
