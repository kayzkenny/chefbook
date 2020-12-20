import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/shared/custom_flat_button.dart';

class EditStepDialog extends HookWidget {
  EditStepDialog({Key key, this.step, this.stepIndex}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final String step;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final stepController = useTextEditingController(text: step);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Step',
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
                      labelText: 'Step',
                      hintText: 'New Step',
                    ),
                    maxLines: 3,
                    controller: stepController,
                    validator: (value) => value.isEmpty ? 'Name' : null,
                  ),
                  SizedBox(height: 20.0),
                  CustomFlatButton(
                    label: Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        context
                            .read(stepsNotifierProvider)
                            .replaceStep(stepController.text, stepIndex);
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
