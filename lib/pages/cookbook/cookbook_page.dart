import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/recipes/recipes_page.dart';
import 'package:chefbook/pages/cookbook/cookbook_card.dart';
import 'package:chefbook/pages/cookbook/new_cookbook_dialog.dart';

class CookbookPage extends HookWidget {
  const CookbookPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final cookbookStream = useProvider(cookbooksProvider);

    getMoreCookbooks() {
      context.read(firestoreRepositoryProvider).requestMoreCookbooks();
    }

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange) {
          getMoreCookbooks();
        }
      });
      return () => scrollController.removeListener(() {});
    }, [scrollController]);

    return cookbookStream.when(
      data: (cookbookList) => Scaffold(
        appBar: AppBar(
          title: Text(
            'My Cookbooks',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SafeArea(
          child: cookbookList.isEmpty
              ? Center(
                  child: Text('No Cookbooks to Show'),
                )
              : ListView.builder(
                  controller: scrollController,
                  padding: EdgeInsets.all(20.0),
                  itemCount: cookbookList.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final cookbook = cookbookList[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          RecipesPage.routeName,
                          arguments: cookbook,
                        );
                      },
                      child: CookbookCard(
                        cookbook: cookbookList[index],
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
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
