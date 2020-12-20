import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chefbook/models/recipe.dart';
import 'package:chefbook/services/storage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/image_picker.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/services/firestore_database.dart';

class RecipeImagePicker extends HookWidget {
  RecipeImagePicker({this.recipe, Key key}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    final ValueNotifier<File> image = useState();

    Future<File> getImage() async =>
        await context.read(imagePickerProvider).getImage();

    Future<void> deleteImage(String imageURL) async {
      await context
          .read(databaseProvider)
          .deleteRecipeImage(recipeId: recipe.id);
      await context.read(storageProvider).deleteFile(imageURL);
    }

    Future<void> saveImage(File imageFile) async {
      final String downloadURL =
          await context.read(storageProvider).uploadFile(imageFile);
      await context
          .read(databaseProvider)
          .updateRecipeImage(imageURL: downloadURL, recipeId: recipe.id);
    }

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Upload New Cookbook Cover',
              style: Theme.of(context).textTheme.headline5,
            ),
            if (image.value != null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.file(
                  image.value,
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            if (recipe.imageURL != null && image.value == null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  recipe.imageURL,
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            if (recipe.imageURL == null && image.value == null)
              CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.brown,
                child: Text(
                  'No Cover',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (loading.value == true)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                if (image.value == null &&
                    recipe.imageURL == null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'UPLOAD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final pickedFile = await getImage();
                      image.value = pickedFile;
                    },
                  ),
                if (image.value == null &&
                    recipe.imageURL != null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'DELETE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await deleteImage(recipe.imageURL);
                      loading.value = false;
                      Navigator.pop(context);
                    },
                  ),
                if (image.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await saveImage(image.value);
                      loading.value = false;
                      image.value = null;
                      Navigator.pop(context);
                    },
                  ),
                if (image.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'REMOVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      image.value = null;
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
