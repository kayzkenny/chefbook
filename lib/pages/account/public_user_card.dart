import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
// import 'package:chefbook/pages/recipes/public_user_page.dart';

class PublicUserCard extends StatelessWidget {
  const PublicUserCard({@required this.publicUserData, Key key})
      : super(key: key);

  final UserData publicUserData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.pushNamed(
      //     context,
      //     PublicUserPage.routeName,
      //     arguments: publicUserData,
      //   );
      // },
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: publicUserData.avatar == null
                  ? AssetImage('images/logo.jpg')
                  : NetworkImage(publicUserData.avatar),
            ),
            SizedBox(width: 10.0),
            Text(
              '${publicUserData.firstName} ${publicUserData.lastName}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            // Spacer(),
            // Text(
            //   '${publicUserData.recipes?.length ?? 0} Recipes',
            //   style: Theme.of(context).textTheme.bodyText2,
            // ),
          ],
        ),
      ),
    );
  }
}
