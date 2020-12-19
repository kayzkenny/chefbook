import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';

class EditCookbookDialog extends HookWidget {
  EditCookbookDialog({Key key, @required this.cookbook}) : super(key: key);

  final snackBar = SnackBar(
    content: Text('Cookbook Updated'),
    backgroundColor: Colors.brown[700],
  );
  final _formKey = GlobalKey<FormState>();
  final Cookbook cookbook;

  @override
  Widget build(BuildContext context) {
    final cookbookNameController = useTextEditingController();

    Future<void> updateCookbook(Cookbook updatedCookbook) async => await context
        .read(databaseProvider)
        .updateCookbook(cookbook: updatedCookbook);

    return AlertDialog(
      title: Text(
        'Edit Cookbook',
        style: TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration().copyWith(
            labelText: 'Name',
            hintText: 'Rename Cookbook',
          ),
          controller: cookbookNameController,
          validator: (value) => value.isEmpty ? 'Name' : null,
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            'CANCEL',
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text(
            'SAVE',
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              Cookbook editedCookbook = Cookbook(
                id: cookbook.id,
                lastUpdated: DateTime.now(),
                name: cookbookNameController.text,
              );
              await updateCookbook(editedCookbook);
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}
