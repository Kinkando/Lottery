import 'package:flutter/material.dart';
import 'package:lottery/views/home_page.dart';
import 'package:lottery/views/reward_check_page.dart';
import 'package:lottery/views/statistic_page.dart';

class MyScaffold extends StatefulWidget {
  const MyScaffold({Key? key}) : super(key: key);

  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  var _selectedBottomNavIndex = 0;
  final _viewList = [
    const HomePage(),
    const RewardCheckPage(),
    const StatisticPage(),
  ];
  final _buttonNavigatorItem = [
    {
      "title": "สลากกินแบ่งรัฐบาล",
      "icon": const Icon(Icons.menu_book),
      "label": "หน้าหลัก",
    },
    {
      "title": "สลากกินแบ่งรัฐบาล",
      "icon": const Icon(Icons.shopping_cart),
      "label": "ตรวจรางวัล",
    },
    {
      "title": "สลากกินแบ่งรัฐบาล",
      "icon": const Icon(Icons.shopping_cart),
      "label": "สถิติหวย",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_buttonNavigatorItem[_selectedBottomNavIndex]['title'] as String),
      ),
      body: SafeArea(
        child: IndexedStack( // Not Reloading all widgets each time
          index: _selectedBottomNavIndex,
          children: _viewList,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          for(var i=0; i<_buttonNavigatorItem.length; i++)
            BottomNavigationBarItem(
              icon: _buttonNavigatorItem[i]["icon"] as Icon,
              label: _buttonNavigatorItem[i]["label"] as String,
            )
        ],
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          setState(() {
            _selectedBottomNavIndex = index;
          });
        },
      ),
    );
  }
}