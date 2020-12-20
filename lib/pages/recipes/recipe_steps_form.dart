import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/pages/recipes/new_step_dialog.dart';
import 'package:chefbook/pages/recipes/edit_step_dialog.dart';

class RecipeStepsForm extends ConsumerWidget {
  const RecipeStepsForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final stepsNotifierState = watch(stepsNotifierProvider.state);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: CustomFlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewStepDialog(),
                  fullscreenDialog: true,
                ),
              );
            },
            label: Text(
              'ADD',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        stepsNotifierState.length == 0
            ? Center(
                child: Text('No Steps to Show'),
              )
            : Expanded(
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) {
                    context
                        .read(stepsNotifierProvider)
                        .swapSteps(oldIndex, newIndex);
                  },
                  children: List.generate(
                    stepsNotifierState.length,
                    (index) {
                      final step = stepsNotifierState[index];
                      return Dismissible(
                        key: Key(step),
                        onDismissed: (direction) {
                          context.read(stepsNotifierProvider).deleteStep(step);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditStepDialog(
                                  step: step,
                                  stepIndex: index,
                                ),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(stepsNotifierState[index]),
                            leading: Icon(Icons.drag_handle),
                          ),
                        ),
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerStart,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
