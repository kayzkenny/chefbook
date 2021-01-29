import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/shared/custom_flat_button.dart';

class NewIngredientDialog extends HookWidget {
  NewIngredientDialog({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ingredientController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Ingredient',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration().copyWith(
                      labelText: 'Ingredient',
                      hintText: 'New Ingredient',
                    ),
                    maxLines: 3,
                    controller: ingredientController,
                    validator: (value) => value.isEmpty ? 'Name' : null,
                  ),
                  SizedBox(height: 20.0),
                  CustomFlatButton(
                    label: Text(
                      'ADD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        context
                            .read(ingredientsNotifierProvider)
                            .addIngredient(ingredientController.text);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
