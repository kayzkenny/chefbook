import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chefbook/shared/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chefbook/pages/landing_page.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chefbook/pages/recipes/recipe_form.dart';
import 'package:chefbook/pages/recipes/recipes_page.dart';
import 'package:chefbook/pages/account/profile_page.dart';
import 'package:chefbook/pages/account/network_page.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:chefbook/pages/recipes/recipe_detail_page.dart';
// import 'package:chefbook/pages/recipes/public_user_page.dart';
// import 'package:chefbook/pages/recipes/my_recipes_page.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:chefbook/pages/feed/user_recipe_detail_page.dart';
// import 'package:chefbook/pages/recipes/my_recipe_detail_page.dart';

FirebaseAnalytics analytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Restric device orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chef Book',

      // Named Routes
      routes: {
        RecipeForm.routeName: (context) => RecipeForm(),
        // SearchPage.routeName: (context) => SearchPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
        NetworkPage.routeName: (context) => NetworkPage(),
        RecipesPage.routeName: (context) => RecipesPage(),
        // PublicUserPage.routeName: (context) => PublicUserPage(),
        RecipeDetailPage.routeName: (context) => RecipeDetailPage(),
        // UserRecipeDetailPage.routeName: (context) => UserRecipeDetailPage(),
      },

      home: LandingPage(),

      // Firebase Analytics
      navigatorObservers: [
        FirebaseAnalyticsObserver(
          analytics: FirebaseAnalytics(),
        ),
      ],

      // App Theme
      theme: lightThemeData,
      darkTheme: darkThemeData,
    );
  }
}
