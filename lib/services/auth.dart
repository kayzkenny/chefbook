// import 'package:flutter/services.dart';
import 'package:chefbook/models/user.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

final authProvider = Provider((ref) => Auth());

abstract class AuthBase {
  Stream<User> get onAuthStateChanged;
  User currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  // Future<User> signInWithGoogle();
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = auth.FirebaseAuth.instance;

  User _userFromFirebase(auth.User user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  User currentUser() {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  // @override
  // Future<User> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final googleUser = await GoogleSignIn().signIn();

  //   if (googleUser != null) {
  //     // Obtain the auth details from the request
  //     final googleAuth = await googleUser.authentication;

  //     if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //       // Create a new credential
  //       final credential = auth.GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

  //       final authResult =
  //           await auth.FirebaseAuth.instance.signInWithCredential(credential);
  //       // Once signed in, return the UserCredential
  //       return _userFromFirebase(authResult.user);
  //     } else {
  //       throw PlatformException(
  //         code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //         message: 'Missing Google Auth Token',
  //       );
  //     }
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_ABORTED_BY_USER',
  //       message: 'Sign in aborted by user',
  //     );
  //   }

  // final googleSignIn = GoogleSignIn();
  // final googleAccount = await googleSignIn.signIn();
  // if (googleAccount != null) {
  //   final googleAuth = await googleAccount.authentication;
  //   if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //     final authResult = await _firebaseAuth.signInWithCredential(
  //       auth.AuthCredential(
  //         providerId: googleAuth.idToken,
  //         signInMethod: 'password',
  //       ),
  //     );
  //     return _userFromFirebase(authResult.user);
  //   } else {
  //     throw PlatformException(
  //       code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
  //       message: 'Missing Google Auth Token',
  //     );
  //   }
  // } else {
  //   throw PlatformException(
  //     code: 'ERROR_ABORTED_BY_USER',
  //     message: 'Sign in aborted by user',
  //   );
  // }
  // }

  @override
  Future<void> signOut() async {
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
