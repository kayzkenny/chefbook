import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipes_page.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/cookbook/cookbook_card.dart';
import 'package:chefbook/pages/cookbook/new_cookbook_dialog.dart';

class CookbookPage extends ConsumerWidget {
  const CookbookPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cookbooksStream = watch(cookbooksProvider);

    return cookbooksStream.when(
      data: (cookbooks) => CookbookList(cookbooks: cookbooks),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}

class CookbookList extends HookWidget {
  const CookbookList({Key key, this.cookbooks}) : super(key: key);

  final List<Cookbook> cookbooks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cookbooks',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SafeArea(
        child: cookbooks.length == 0
            ? Center(
                child: Text('No Cookbooks to Show'),
              )
            : ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: cookbooks.length,
                itemBuilder: (BuildContext context, int index) {
                  final cookbook = cookbooks[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        RecipesPage.routeName,
                        arguments: cookbook,
                      );
                    },
                    child: CookbookCard(
                      cookbook: cookbooks[index],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => NewCookbookDialog(),
          );
        },
        child: Icon(Icons.add),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
    );
  }
}
