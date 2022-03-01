import 'package:flutter/material.dart';

class RewardCheckPage extends StatefulWidget {
  // static const routeName = '/reward';

  const RewardCheckPage({Key? key}) : super(key: key);

  @override
  _RewardCheckPageState createState() => _RewardCheckPageState();
}

class _RewardCheckPageState extends State<RewardCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text('REWARD')
          )
        ],
      ),
    );
  }
}
