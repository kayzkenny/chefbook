import 'package:meta/meta.dart';

class User {
  User({
    @required this.uid,
    this.photoUrl,
    this.displayName,
  });
  final String uid;
  final String photoUrl;
  final String displayName;
}

class UserData {
  final String uid;
  final String email;
  final String avatar;
  final String lastName;
  final String firstName;
  final int recipeCount;
  final int cookbookCount;
  final int followerCount;
  final int followingCount;

  UserData({
    @required this.lastName,
    @required this.firstName,
    this.uid,
    this.email,
    this.avatar,
    this.recipeCount,
    this.cookbookCount,
    this.followerCount,
    this.followingCount,
  });

  /// Convert userData to map such as a firestore document
  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'firstName': firstName,
    };
  }

  /// Construct userData from a map sucg as a firestore document
  factory UserData.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }

    final String uid = documentId;
    final String email = data['email'];
    final String avatar = data['avatar'];
    final String lastName = data['lastName'];
    final String firstName = data['firstName'];
    final int recipeCount = data['recipeCount'];
    final int cookbookCount = data['cookbookCount'];
    final int followerCount = data['followerCount'];
    final int followingCount = data['followingCount'];

    return UserData(
      uid: uid,
      email: email,
      avatar: avatar ?? null,
      lastName: lastName ?? null,
      firstName: firstName ?? null,
      recipeCount: recipeCount ?? 0,
      cookbookCount: cookbookCount ?? 0,
      followerCount: followerCount ?? 0,
      followingCount: followingCount ?? 0,
    );
  }
}
