import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/cookbook/edit_cookbook.dialog.dart';
import 'package:chefbook/pages/cookbook/cookbook_cover_picker.dart';

enum CookbookAction { rename, editBookCover, delete }

class CookbookCard extends StatelessWidget {
  const CookbookCard({Key key, this.cookbook}) : super(key: key);

  final Cookbook cookbook;

  @override
  Widget build(BuildContext context) {
    void _showEditCookbookForm() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => EditCookbookDialog(cookbook: cookbook),
      );
    }

    void _showCookbookCoverPicker() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            CookBookCoverPicker(cookbook: cookbook),
      );
    }

    Future<void> deleteCookbook() async {
      final bool result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Cookbook'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delte this recipe?'),
                  Text(
                    'All recipes associated with this cookbook will also be deleted',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('DELETE'),
                onPressed: () {
                  context
                      .read(databaseProvider)
                      .deleteCookbook(cookbookId: cookbook.id);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );

      if (result == true) {
        context.read(databaseProvider).deleteCookbook(cookbookId: cookbook.id);
      } else {
        print("Canceled Pressed");
      }
    }

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
                'images/logo.jpg',
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
              Row(
                children: [
                  Text(
                    '${cookbook.recipeCount} Recipes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  PopupMenuButton<CookbookAction>(
                    onSelected: (CookbookAction action) async {
                      switch (action) {
                        case CookbookAction.rename:
                          _showEditCookbookForm();
                          break;
                        case CookbookAction.editBookCover:
                          _showCookbookCoverPicker();
                          break;
                        case CookbookAction.delete:
                          await deleteCookbook();
                          Navigator.pop(context);
                          break;
                        default:
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<CookbookAction>>[
                      PopupMenuItem<CookbookAction>(
                        value: CookbookAction.rename,
                        child: Text(
                          'Rename',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      PopupMenuItem<CookbookAction>(
                        value: CookbookAction.editBookCover,
                        child: Text(
                          'Edit Book Cover',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      PopupMenuItem<CookbookAction>(
                        value: CookbookAction.delete,
                        child: Text(
                          'Delete Cookbook',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
