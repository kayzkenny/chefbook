import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:chefbook/services/algolia_service.dart';
import 'package:chefbook/pages/feed/user_recipe_card.dart';
import 'package:chefbook/pages/feed/user_recipe_detail_page.dart';

class SearchPage extends HookWidget {
  const SearchPage({Key key}) : super(key: key);

  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    final isMounted = useIsMounted();
    final searching = useState(false);
    final results = useState(<Recipe>[]);
    final searchText = useTextEditingController();

    Future<void> search() async {
      if (isMounted()) {
        searching.value = true;
        try {
          results.value = await AlgoliaService().queryIndex(
            searchText: searchText.text,
          );
        } catch (e) {}
        searching.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: searchText,
          onChanged: (value) => search(),
          // cursorColor: Colors.white,
          onEditingComplete: search,
          style: Theme.of(context).textTheme.headline6,
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: InputBorder.none,
            // focusColor: Colors.white,
            hintText: 'Search recipes...',
            // hintStyle: TextStyle(
            //   color: Colors.white,
            //   decorationColor: Colors.white,
            // ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: search,
          )
        ],
      ),
      body: results.value.isEmpty
          ? Center(
              child: Text('No results to show'),
            )
          : SafeArea(
              child: ListView.builder(
                padding: EdgeInsets.all(20.0),
                itemCount: results.value.length,
                itemBuilder: (BuildContext context, int index) {
                  final recipe = results.value[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        UserRecipeDetailPage.routeName,
                        arguments: recipe.id,
                      );
                    },
                    child: UserRecipeCard(
                      userRecipe: recipe,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
