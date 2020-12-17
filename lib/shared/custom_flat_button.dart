import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final Widget label;
  final Function onPressed;

  const CustomFlatButton({@required this.onPressed, @required this.label});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: label,
      color: Colors.brown,
      // highlightColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
