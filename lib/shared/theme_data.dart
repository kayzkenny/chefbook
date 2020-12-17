import 'package:flutter/material.dart';

ThemeData lightThemeData = ThemeData.light().copyWith(
  accentColor: Colors.brown[700],
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    centerTitle: true,
    color: Colors.white,
    actionsIconTheme: IconThemeData(
      color: Colors.grey[900],
    ),
  ),
  tabBarTheme: TabBarTheme(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.brown[900]),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.brown[900],
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Colors.grey[400],
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.brown[700],
    elevation: 20.0,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.brown[900],
    highlightColor: Colors.white,
  ),
  textTheme: Typography.material2018()
      .white
      .copyWith(
        headline1: TextStyle(
          fontSize: 102.0,
          fontFamily: 'Roboto',
          letterSpacing: -1.5,
          fontWeight: FontWeight.w300,
        ),
        headline2: TextStyle(
          fontSize: 64.0,
          fontFamily: 'Roboto',
          letterSpacing: -0.5,
          fontWeight: FontWeight.w300,
        ),
        headline3: TextStyle(
          fontSize: 51.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.0,
          fontWeight: FontWeight.normal,
        ),
        headline4: TextStyle(
          fontSize: 36.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.25,
          fontWeight: FontWeight.normal,
        ),
        headline5: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.0,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          fontSize: 21.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: TextStyle(
          fontSize: 17.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.15,
          fontWeight: FontWeight.normal,
        ),
        subtitle2: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.5,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.25,
          fontWeight: FontWeight.normal,
        ),
        button: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          color: Colors.brown[50],
          letterSpacing: 1.25,
          fontWeight: FontWeight.w500,
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.4,
          fontWeight: FontWeight.normal,
        ),
        overline: TextStyle(
          fontSize: 10.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 1.5,
          fontWeight: FontWeight.normal,
        ),
      )
      .apply(bodyColor: Colors.black, displayColor: Colors.black),
);

ThemeData darkThemeData = ThemeData.dark().copyWith(
  accentColor: Color.fromRGBO(254, 240, 222, 1.0),
  scaffoldBackgroundColor: Colors.grey[900],
  backgroundColor: Colors.grey[900],
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    centerTitle: true,
    color: Colors.grey[900],
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[900],
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Colors.grey[700],
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Colors.white,
    elevation: 20.0,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.brown[400],
    highlightColor: Colors.brown[900],
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(254, 240, 222, 1.0),
    foregroundColor: Colors.brown[900],
  ),
  tabBarTheme: TabBarTheme(
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.brown[400]),
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.grey[850],
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  textTheme: Typography.material2018()
      .white
      .copyWith(
        headline1: TextStyle(
          fontSize: 102.0,
          fontFamily: 'Roboto',
          letterSpacing: -1.5,
          fontWeight: FontWeight.w300,
        ),
        headline2: TextStyle(
          fontSize: 64.0,
          fontFamily: 'Roboto',
          letterSpacing: -0.5,
          fontWeight: FontWeight.w300,
        ),
        headline3: TextStyle(
          fontSize: 51.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.0,
          fontWeight: FontWeight.normal,
        ),
        headline4: TextStyle(
          fontSize: 36.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.25,
          fontWeight: FontWeight.normal,
        ),
        headline5: TextStyle(
          fontSize: 25.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.0,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          fontSize: 21.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.15,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: TextStyle(
          fontSize: 17.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.15,
          fontWeight: FontWeight.normal,
        ),
        subtitle2: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Roboto',
          letterSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.5,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.25,
          fontWeight: FontWeight.normal,
        ),
        button: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
          color: Colors.brown,
          letterSpacing: 1.25,
          fontWeight: FontWeight.w500,
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 0.4,
          fontWeight: FontWeight.normal,
        ),
        overline: TextStyle(
          fontSize: 10.0,
          fontFamily: 'Roboto',
          color: Colors.black,
          letterSpacing: 1.5,
          fontWeight: FontWeight.normal,
        ),
      )
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
);
