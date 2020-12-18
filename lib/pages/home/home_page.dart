import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:chefbook/pages/feed/feed_page.dart';
import 'package:chefbook/pages/account/account_page.dart';
import 'package:chefbook/pages/cookbook/cookbook_page.dart';
import 'package:chefbook/pages/favourites/favourites_page.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomePage extends HookWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _selectedIndex = useState(0);

    final _widgetOptions = useState(
      <Widget>[
        FeedPage(),
        CookbookPage(),
        FavouritesPage(),
        AccountPage(),
      ],
    );

    void _onItemTapped(int index) => _selectedIndex.value = index;

    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.value.elementAt(_selectedIndex.value),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        showSelectedLabels: false,
        currentIndex: _selectedIndex.value,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.book),
            label: 'Cookbook',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.heart),
            label: 'Favs',
          ),
          BottomNavigationBarItem(
            icon: Icon(FeatherIcons.user),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
