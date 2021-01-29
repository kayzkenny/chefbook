import 'package:flutter/material.dart';
import 'package:chefbook/services/auth.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';

class NewCookbookDialog extends HookWidget {
  NewCookbookDialog({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Cookbook Created'),
    backgroundColor: Colors.brown[700],
  );

  @override
  Widget build(BuildContext context) {
    final loadingCreateCookbok = useState(false);
    final cookbookNameController = useTextEditingController();

    Future<void> createCookbook(cookbook) async {
      loadingCreateCookbok.value = true;
      await context.read(databaseProvider).createCookbook(cookbook: cookbook);
      loadingCreateCookbok.value = false;
    }

    return AlertDialog(
      title: Text(
        'New Cookbook',
        style: TextStyle(fontSize: 18.0),
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration().copyWith(
            labelText: 'Name',
            hintText: 'My New Cookbook',
          ),
          controller: cookbookNameController,
          validator: (value) => value.isEmpty ? 'Name' : null,
        ),
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('SAVE'),
          onPressed: loadingCreateCookbok.value
              ? () {}
              : () async {
                  if (_formKey.currentState.validate()) {
                    Cookbook cookbook = Cookbook(
                      name: cookbookNameController.text,
                      createdAt: DateTime.now(),
                      createdBy: Auth().currentUser().uid,
                      lastUpdated: DateTime.now(),
                    );
                    await createCookbook(cookbook);
                    Navigator.of(context).pop(true);
                  }
                },
        ),
      ],
    );
  }
}
