import 'package:flutter/material.dart';

void showMaterialDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        // content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                child: const Text('ปิด'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      );
    },
  );
}
