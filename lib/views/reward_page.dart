import 'package:flutter/material.dart';
class RewardPage extends StatefulWidget {
  final List<String> numbers;
  final Map<String, dynamic> rewards;
  const RewardPage({required this.numbers, required this.rewards, Key? key}) : super(key: key);

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  int _index = 0;
  final _controller = PageController(viewportFraction: 0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ผลการตรวจรางวัล'),
        ),
      ),
      body: SizedBox(
        height: 200, // card height
        child: PageView.builder(
          allowImplicitScrolling: true,
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          controller: _controller,
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    "Card ${i + 1}",
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
