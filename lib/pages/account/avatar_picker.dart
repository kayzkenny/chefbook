import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:chefbook/services/storage.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/image_picker.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/services/firestore_database.dart';

class AvatarPicker extends HookWidget {
  const AvatarPicker({@required this.userData, Key key}) : super(key: key);

  final UserData userData;

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    final ValueNotifier<File> avatar = useState();

    Future<File> getImage() async =>
        await context.read(imagePickerProvider).getImage();

    Future<void> deleteAvatar(String avatarURL) async {
      await context.read(databaseProvider).deleteUserAvatar();
      await context.read(storageProvider).deleteFile(avatarURL);
    }

    Future<void> saveAvatar(File avatarFile) async {
      final String downloadURL =
          await context.read(storageProvider).uploadFile(avatarFile);
      await context
          .read(databaseProvider)
          .updateUserAvatar(avatar: downloadURL);
    }

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Upload New Avatar',
              style: Theme.of(context).textTheme.headline5,
            ),
            if (avatar.value != null)
              CircleAvatar(
                radius: 100.0,
                backgroundImage: FileImage(avatar.value),
              ),
            if (userData.avatar != null && avatar.value == null)
              CircleAvatar(
                radius: 100.0,
                backgroundImage: NetworkImage(userData.avatar),
              ),
            if (userData.avatar == null && avatar.value == null)
              CircleAvatar(
                radius: 100.0,
                backgroundColor: Colors.brown,
                child: userData.firstName == null
                    ? Text(
                        'N/A',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.white),
                      )
                    : Text(
                        '${userData.firstName.substring(0, 1)} ${userData.lastName.substring(0, 1)}',
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
                if (avatar.value == null &&
                    userData.avatar == null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'UPLOAD',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final pickedFile = await getImage();
                      avatar.value = pickedFile;
                    },
                  ),
                if (avatar.value == null &&
                    userData.avatar != null &&
                    loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'DELETE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await deleteAvatar(userData.avatar);
                      loading.value = false;
                      Navigator.pop(context);
                    },
                  ),
                if (avatar.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      loading.value = true;
                      await saveAvatar(avatar.value);
                      loading.value = false;
                      avatar.value = null;
                      Navigator.pop(context);
                    },
                  ),
                if (avatar.value != null && loading.value == false)
                  CustomFlatButton(
                    label: Text(
                      'REMOVE',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      avatar.value = null;
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
