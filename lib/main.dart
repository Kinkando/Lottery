import 'package:flutter/material.dart';
import 'package:lottery/views/widgets/my_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Color backgroundColor = Colors.white;
  static Color foregroundColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lottery Unikume',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyScaffold(),
    );
  }
}