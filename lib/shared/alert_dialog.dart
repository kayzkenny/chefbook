import 'package:flutter/material.dart';

Future<void> showAlertDialog({@required BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Your Offline'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Check if you are connected to the internet'),
              SizedBox(height: 10.0),
              Text('Or try switching to WiFi from mobile data'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
