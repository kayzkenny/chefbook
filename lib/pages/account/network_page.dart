import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/repository/firestore_repo.dart';
import 'package:chefbook/pages/account/public_user_card.dart';

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
    final followingStream = useProvider(paginatedFollowingProvider);
    final followersStream = useProvider(paginatedFollowersProvider);

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
                : followingStream.when(
                    data: (following) => ListView.separated(
                      padding: EdgeInsets.all(32.0),
                      itemCount: following.length,
                      controller: followingScrollController,
                      separatorBuilder: (context, index) => Divider(),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          PublicUserCard(publicUserData: userData),
                    ),
                    loading: () => Center(
                      child: const CircularProgressIndicator(),
                    ),
                    error: (error, stack) =>
                        Center(child: Text('${error.toString()}')),
                  ),
            userData.followerCount == 0
                ? Center(
                    child: Text('You have no followers'),
                  )
                : followersStream.when(
                    data: (followers) => ListView.separated(
                      padding: const EdgeInsets.all(32.0),
                      itemCount: followers.length,
                      controller: followersScrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return PublicUserCard(publicUserData: userData);
                      },
                    ),
                    loading: () => Center(
                      child: const CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('${error.toString()}'),
                    ),
                  ),
          ],
        ),
      ),
      loading: () => Center(
        child: const CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: const Text('Something went wrong'),
      ),
    );
  }
}
