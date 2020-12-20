import 'package:flutter/material.dart';

class RecipeStat extends StatelessWidget {
  const RecipeStat({
    @required this.label,
    @required this.icon,
    Key key,
  }) : super(key: key);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Icon(
            icon,
            size: 30.0,
            color: Colors.brown,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
