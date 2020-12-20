import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chefbook/models/cookbook.dart';
import 'package:chefbook/services/storage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/image_picker.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/services/firestore_database.dart';

class CookBookCoverPicker extends HookWidget {
  const CookBookCoverPicker({this.cookbook, Key key}) : super(key: key);

  final Cookbook cookbook;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    final ValueNotifier<File> cover = useState();

    Future<File> getImage() async =>
        await context.read(imagePickerProvider).getImage();

    Future<void> deleteCover(String coverURL) async {
      await context
          .read(databaseProvider)
          .deleteCookbookCover(cookbookID: cookbook.id);
      await context.read(storageProvider).deleteFile(coverURL);
    }

    Future<void> saveCover(File coverFile) async {
      final String downloadURL =
          await context.read(storageProvider).uploadFile(coverFile);
      await context
          .read(databaseProvider)
          .updateCookbookCover(coverURL: downloadURL, cookbookID: cookbook.id);
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
            if (cover.value != null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.file(
                  cover.value,
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            if (cookbook.coverURL != null && cover.value == null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Image.network(
                  cookbook.coverURL,
                  height: 200.0,
                  width: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            if (cookbook.coverURL == null && cover.value == null)
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
                if (cover.value == null &&
                    cookbook.coverURL == null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'UPLOAD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final pickedFile = await getImage();
                      cover.value = pickedFile;
                    },
                  ),
                if (cover.value == null &&
                    cookbook.coverURL != null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'DELETE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await deleteCover(cookbook.coverURL);
                      loading.value = false;
                      Navigator.pop(context);
                    },
                  ),
                if (cover.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await saveCover(cover.value);
                      loading.value = false;
                      cover.value = null;
                      Navigator.pop(context);
                    },
                  ),
                if (cover.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'REMOVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      cover.value = null;
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
