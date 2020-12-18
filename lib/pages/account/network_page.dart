import 'package:flutter/material.dart';
import 'package:chefbook/models/user.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/services/firestore_database.dart';
import 'package:chefbook/pages/account/public_user_card.dart';

class NetworkPage extends HookWidget {
  const NetworkPage({Key key}) : super(key: key);

  static const routeName = '/mynetwork';

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // final UserData userData = ModalRoute.of(context).settings.arguments;
    // final following =
    //     useProvider(followingProvider(userData?.following))?.data?.value;
    // final followers =
    //     useProvider(followersProvider(userData?.followers))?.data?.value;

    // final tabKey = GlobalKey();
    // final tabIndex = useState(0);
    // final tabController = useTabController(initialLength: 2);

    // tabController.addListener(() => tabIndex.value = tabController.index);

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(
    //       'My Network',
    //       style: Theme.of(context).textTheme.headline6,
    //     ),
    //     bottom: TabBar(
    //       onTap: (index) {},
    //       controller: tabController,
    //       tabs: [
    //         Tab(
    //           child: Text(
    //             '${following?.length ?? 0} Following',
    //             style: Theme.of(context).textTheme.button,
    //           ),
    //         ),
    //         Tab(
    //           child: Text(
    //             '${followers?.length ?? 0} Followers',
    //             style: Theme.of(context).textTheme.button,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   body: TabBarView(
    //     key: tabKey,
    //     controller: tabController,
    //     children: [
    //       // if (following != null)
    //       following == null
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : following.length == 0
    //               ? Center(
    //                   child: Text('You are not following anyone'),
    //                 )
    //               : ListView.separated(
    //                   itemCount: following.length,
    //                   padding: EdgeInsets.all(32.0),
    //                   separatorBuilder: (context, index) => Divider(),
    //                   itemBuilder: (BuildContext context, int index) {
    //                     final userFollowing = following[index];
    //                     return PublicUserCard(publicUserData: userFollowing);
    //                   },
    //                 ),
    //       // if (followers != null)
    //       followers == null
    //           ? Center(
    //               child: CircularProgressIndicator(),
    //             )
    //           : followers.length == 0
    //               ? Center(
    //                   child: Text('You have no followers'),
    //                 )
    //               : ListView.separated(
    //                   itemCount: followers.length,
    //                   padding: EdgeInsets.all(32.0),
    //                   separatorBuilder: (context, index) => Divider(),
    //                   itemBuilder: (BuildContext context, int index) {
    //                     final userFollower = followers[index];
    //                     return PublicUserCard(publicUserData: userFollower);
    //                   },
    //                 ),
    //     ],
    //   ),
    // );
  }
}
