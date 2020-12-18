import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chefbook/services/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/shared/custom_flat_button.dart';
// import 'package:chefbook/shared/custom_image_button.dart';
import 'package:chefbook/shared/platform_exception_alert_dialog.dart';

class SignInPage extends HookWidget {
  SignInPage({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loading = useState(false);
    final passwordHidden = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void _showSignInError(PlatformException exception) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: exception,
      ).show(context);
    }

    // Future<void> signInGoogle() async {
    //   loading.value = true;
    //   try {
    //     await context.read(authProvider).signInWithGoogle();
    //   } on PlatformException catch (e) {
    //     loading.value = false;
    //     _showSignInError(e);
    //   }
    // }

    Future<void> signInWithEmailAndPassword() async {
      loading.value = true;
      try {
        await context.read(authProvider).signInWithEmailAndPassword(
              emailController.text,
              passwordController.text,
            );
      } on PlatformException catch (e) {
        loading.value = false;
        _showSignInError(e);
      }
    }

    void togglePasswordVisibility() =>
        passwordHidden.value = !passwordHidden.value;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 20.0),
            // GestureDetector(
            //   onTap: signInGoogle,
            //   child: CustomImageButton(
            //     imageUrl: "images/google-logo.png",
            //     labelText: "Continue with Google",
            //     color: Theme.of(context).cardTheme.color,
            //     labelTextColor: Colors.black,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 40.0),
            //   child: Center(
            //     child: Text('Or'),
            //   ),
            // ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration().copyWith(
                        labelText: 'Email',
                        hintText: 'example@gmail.com',
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Enter an email' : null,
                      controller: emailController,
                    ),
                    SizedBox(height: 20.0),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration().copyWith(
                            labelText: 'Password',
                            hintText: '********',
                          ),
                          obscureText: passwordHidden.value,
                          validator: (value) => value.length < 8
                              ? 'Enter at least password 8 characters long'
                              : null,
                          controller: passwordController,
                        ),
                        passwordHidden.value
                            ? IconButton(
                                icon: Icon(Icons.visibility_off),
                                color: Colors.grey,
                                onPressed: () {
                                  togglePasswordVisibility();
                                },
                              )
                            : IconButton(
                                icon: Icon(Icons.visibility),
                                color: Colors.grey,
                                onPressed: () {
                                  togglePasswordVisibility();
                                },
                              ),
                      ],
                    ),
                    Text(
                      'Your password must be eight characters or more and contain at least one letter or special character.',
                      style: TextStyle(color: Colors.grey, fontSize: 10.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40.0),
            CustomFlatButton(
              label: loading.value == true
                  ? CircularProgressIndicator()
                  : Text(
                      'SIGN IN',
                      style: TextStyle(color: Colors.white),
                    ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await signInWithEmailAndPassword();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
