import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';

class RecipeIntroForm extends HookWidget {
  const RecipeIntroForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tagsController = useTextEditingController();
    final recipeIntro = useProvider(recipeNotifierProvider.state);
    final nameController = useTextEditingController(text: recipeIntro.name);
    final descriptionController =
        useTextEditingController(text: recipeIntro.description);
    final servesController =
        useTextEditingController(text: recipeIntro.serves.toString());
    final durationController =
        useTextEditingController(text: recipeIntro.duration.toString());
    final caloriesPerServingController = useTextEditingController(
        text: recipeIntro.caloriesPerServing.toString());

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration().copyWith(
              labelText: 'Recipe Name',
              hintText: 'Recipe Name',
            ),
            validator: (value) => value.isEmpty ? 'Recipe Name' : null,
            controller: nameController,
            onChanged: (value) =>
                context.read(recipeNotifierProvider).updateName(value),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration().copyWith(
                    labelText: 'Serves',
                    hintText: '4',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value.isEmpty ? 'Serves' : null,
                  controller: servesController,
                  onChanged: (value) => context
                      .read(recipeNotifierProvider)
                      .updateServes(int.tryParse(value)),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration().copyWith(
                    labelText: 'Duration',
                    hintText: '50',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value.isEmpty ? 'Duration' : null,
                  controller: durationController,
                  onChanged: (value) => context
                      .read(recipeNotifierProvider)
                      .updateDuration(int.tryParse(value)),
                ),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration().copyWith(
                    labelText: 'Calories',
                    hintText: '670',
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value.isEmpty ? 'Calories' : null,
                  controller: caloriesPerServingController,
                  onChanged: (value) => context
                      .read(recipeNotifierProvider)
                      .updateCaloriesPerServing(int.tryParse(value)),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          TextFormField(
            decoration: InputDecoration().copyWith(
              labelText: 'Description',
              hintText: 'Description',
            ),
            maxLines: 4,
            validator: (value) => value.isEmpty ? 'Calories' : null,
            controller: descriptionController,
            onChanged: (value) =>
                context.read(recipeNotifierProvider).updateDescription(value),
          ),
          SizedBox(height: 20.0),
          RecipeTags(),
          SizedBox(height: 10.0),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextFormField(
                decoration: InputDecoration().copyWith(
                  labelText: 'Add Tags',
                  hintText: 'Tags',
                ),
                controller: tagsController,
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                color: Colors.grey,
                onPressed: () => {
                  if (tagsController.text.length > 0)
                    {
                      context
                          .read(tagsNotifierProvider)
                          .addTag(tagsController.text),
                      tagsController.clear(),
                    }
                },
              ),
            ],
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class RecipeTags extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final tagsNotifierState = watch(tagsNotifierProvider.state);

    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      direction: Axis.horizontal,
      children: List.generate(
        tagsNotifierState.length,
        (index) {
          final tag = tagsNotifierState[index];
          return tagsNotifierState.length == 0
              ? Center(
                  child: Text('No Tags to Show'),
                )
              : Chip(
                  label: Text(tag),
                  deleteIcon: Icon(Icons.close),
                  onDeleted: () =>
                      context.read(tagsNotifierProvider).deleteTag(tag),
                );
        },
      ),
    );
  }
}
