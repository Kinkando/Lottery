import 'package:flutter/material.dart';
import 'package:lottery/models/lottery.dart';
// import 'package:lottery/pages/home_page.dart';
// import 'package:lottery/pages/reward_check_page.dart';
// import 'package:lottery/pages/statistic_page.dart';
import 'package:lottery/pages/widgets/my_scaffold.dart';
import 'package:lottery/services/api.dart';

Future<List<dynamic>> _fetchLottery() async {
  String date = "2565-01-17";
  List list = await Api().fetch('server.php', queryParams: {"drawdate": date});
  final result = list.map((item) => Lottery.fromJson(item, date)).toList();
  print(date);
  result.forEach((element) {
    print(element.id);
    print(element.name);
    print(element.reward);
    print(element.amount);
    print(element.number);
  });
  return result;
}

void main() {
  // _fetchLottery();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Color backgroundColor = Colors.white;
  static Color foregroundColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery Unikuma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyScaffold(),
      // routes: {
        // SplashScreen.routeName: (context) => const SplashScreen(),
        // HomePage.routeName: (context) => const HomePage(),
        // RewardCheckPage.routeName: (context) => const RewardCheckPage(),
        // StatisticPage.routeName: (context) => const StatisticPage(),
      // },
      // initialRoute: HomePage.routeName,
      // initialRoute: SplashScreen.routeName,
    );
  }
}