import 'package:flutter/gestures.dart';
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
      scrollBehavior: AppScrollBehavior(), // PageView swipeable on web
      debugShowCheckedModeBanner: false,
      title: 'Lottery Unikume',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyScaffold(),
    );
  }
}

// PageView swipeable on web
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}