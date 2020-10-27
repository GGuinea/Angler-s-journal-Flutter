import 'package:flutter/material.dart';

  Future<void> printOutput(String output, BuildContext context) async {
    return await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(title: Text('$output'), actions: <Widget>[
            TextButton(
              child: Text(
                'Ok',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
        });
  }
