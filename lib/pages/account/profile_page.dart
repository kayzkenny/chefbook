import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/account/avatar_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ProfilePage extends ConsumerWidget {
  ProfilePage({Key key}) : super(key: key);

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userDataStream = watch(userDataProvider);

    return userDataStream.when(
      data: (userData) => ProfileForm(userData: userData),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}

class ProfileForm extends HookWidget {
  ProfileForm({this.userData, Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final UserData userData;
  final _formKey = GlobalKey<FormState>();
  final snackBar = SnackBar(
    content: Text('Profile Updated'),
    backgroundColor: Colors.brown[700],
  );

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(
      text: userData.firstName,
    );
    final lastNameController = useTextEditingController(
      text: userData.lastName,
    );
    final loading = useState(false);

    void _showImagePickerView() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => AvatarPicker(userData: userData),
      );
    }

    Future<void> updateUserData(UserData userData) async =>
        await context.read(databaseProvider).updateUserData(userData: userData);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: SizedBox(
                      height: 200.0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          if (userData.avatar != null)
                            CircleAvatar(
                              radius: 100.0,
                              backgroundImage: NetworkImage(userData.avatar),
                            ),
                          if (userData.avatar == null)
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
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.brown,
                            ),
                            child: IconButton(
                              icon: Icon(FeatherIcons.edit2),
                              color: Colors.white,
                              onPressed: _showImagePickerView,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  TextFormField(
                    decoration: InputDecoration().copyWith(
                      labelText: 'First Name',
                      hintText: 'First Name',
                    ),
                    validator: (value) => value.isEmpty ? 'First Name' : null,
                    controller: firstNameController,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration()
                        .applyDefaults(
                          Theme.of(context).inputDecorationTheme,
                        )
                        .copyWith(
                          labelText: 'Last Name',
                          hintText: 'Last Name',
                        ),
                    validator: (value) => value.isEmpty ? 'Last Name' : null,
                    controller: lastNameController,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    userData.email,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 40.0),
                  loading.value == true
                      ? Center(child: CircularProgressIndicator())
                      : CustomFlatButton(
                          label: Text(
                            'UPDATE',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              UserData _formUserData = UserData(
                                firstName: firstNameController.text ??
                                    userData.firstName,
                                lastName: lastNameController.text ??
                                    userData.lastName,
                              );
                              loading.value = true;
                              await updateUserData(_formUserData);
                              loading.value = false;
                              _scaffoldKey.currentState.showSnackBar(snackBar);
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
