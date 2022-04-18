import 'package:flutter/material.dart';

class RewardPage extends StatelessWidget {
  final List<String> numbers;
  final Map<String, dynamic> rewards;

  const RewardPage({required this.numbers, required this.rewards, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ผลการตรวจรางวัล'),
        ),
      ),
    );
  }
}
