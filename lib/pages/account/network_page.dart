import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';

class NetworkPage extends HookWidget {
  const NetworkPage({Key key}) : super(key: key);

  static const routeName = '/mynetwork';

  @override
  Widget build(BuildContext context) {
    final tabKey = GlobalKey();
    final tabIndex = useState(0);
    final userDataStream = useProvider(userDataProvider);
    final followingScrollController = useScrollController();
    final followersScrollController = useScrollController();
    final tabController = useTabController(initialLength: 2);

    tabController.addListener(() => tabIndex.value = tabController.index);

    getMoreFollowing() =>
        context.read(firestoreRepositoryProvider).requestMoreFollowing();

    getMoreFollowers() =>
        context.read(firestoreRepositoryProvider).requestMoreFollowers();

    useEffect(() {
      followingScrollController.addListener(() {
        if (followingScrollController.offset >=
                followingScrollController.position.maxScrollExtent &&
            !followingScrollController.position.outOfRange) {
          getMoreFollowing();
        }
      });

      followersScrollController.addListener(() {
        if (followersScrollController.offset >=
                followersScrollController.position.maxScrollExtent &&
            !followersScrollController.position.outOfRange) {
          getMoreFollowers();
        }
      });

      return () => {
            followingScrollController.removeListener(() {}),
            followersScrollController.removeListener(() {})
          };
    }, [followingScrollController, followersScrollController]);

    return userDataStream.when(
      data: (userData) => Scaffold(
        appBar: AppBar(
          title: Text(
            'My Network',
            style: Theme.of(context).textTheme.headline6,
          ),
          bottom: TabBar(
            onTap: (index) {},
            controller: tabController,
            tabs: [
              Tab(
                child: Text(
                  '${userData.followingCount ?? 0} Following',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
              Tab(
                child: Text(
                  '${userData.followerCount ?? 0} Followers',
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          key: tabKey,
          controller: tabController,
          children: [
            userData.followingCount == 0
                ? Center(
                    child: Text('You are not following anyone'),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(32.0),
                    itemCount: userData.followingCount,
                    controller: followingScrollController,
                    separatorBuilder: (context, index) => Divider(),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // final userFollowing = following[index];
                      // return PublicUserCard(publicUserData: userFollowing);
                      return Text('$index');
                    },
                  ),
            userData.followerCount == 0
                ? Center(
                    child: Text('You have no followers'),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(32.0),
                    itemCount: userData.followingCount,
                    controller: followersScrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      // final userFollower = followers[index];
                      // return PublicUserCard(publicUserData: userFollower);
                      return Text('$index');
                    },
                  ),
          ],
        ),
      ),
      loading: () => Center(child: const CircularProgressIndicator()),
      error: (error, stack) => const Text('Oops'),
    );
  }
}
