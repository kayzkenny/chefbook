import 'package:meta/meta.dart';
import 'package:chefbook/models/user.dart';

class UserDataSocial {
  final UserData userData;
  final bool isFollowed;

  UserDataSocial({
    @required this.userData,
    @required this.isFollowed,
  });

  /// Convert userData to map such as a firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': userData.uid,
      'email': userData.email,
      'avatar': userData.avatar,
      'lastName': userData.lastName,
      'firstName': userData.firstName,
      'recipeCount': userData.recipeCount,
      'cookbookCount': userData.cookbookCount,
      'followerCount': userData.followerCount,
      'followingCount': userData.followingCount,
    };
  }

  /// Construct userData from a map sucg as a firestore document
  factory UserDataSocial.fromMap(Map<String, dynamic> data, String documentId) {
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

    return UserDataSocial(
      userData: UserData(
        uid: uid,
        email: email,
        avatar: avatar ?? null,
        lastName: lastName ?? null,
        firstName: firstName ?? null,
        recipeCount: recipeCount ?? 0,
        cookbookCount: cookbookCount ?? 0,
        followerCount: followerCount ?? 0,
        followingCount: followingCount ?? 0,
      ),
      isFollowed: true,
    );
  }
}
