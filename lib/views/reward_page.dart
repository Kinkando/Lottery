import 'package:flutter/material.dart';
import 'package:lottery/utils/constant.dart';

class RewardPage extends StatefulWidget {
  final List<String> numbers;
  final Map<String, dynamic> rewards;
  final String date;
  const RewardPage({required this.numbers, required this.rewards, required this.date, Key? key}) : super(key: key);

  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  int _index = 0;
  final _controller = PageController(viewportFraction: 0.7);
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('ผลการตรวจรางวัล'),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: widget.numbers.length,
                controller: _controller,
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, index) {
                  return Transform.scale(
                    scale: index == _index ? 1 : 0.9,
                    child: Card(
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: ListView(
                        padding: const EdgeInsets.all(20.0),
                        controller: _scrollController,
                        children: [
                          Center(child: Text('ใบที่ ${index+1}/${widget.numbers.length}')),
                          Center(child: Text(dateFormat(widget.date))),
                          Center(child: Text(widget.numbers[index])),
                          _buildRewardDetail(widget.numbers[index]),
                        ],
                      )
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for(int i=0; i<widget.numbers.length; i++)
                    Icon(
                      Icons.circle,
                      color: i==_index ? Colors.blue : Colors.blue.shade100,
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRewardDetail(String lotteryNumber) {
    if(widget.rewards[lotteryNumber] == null) {
      return const Center(child: Text('ไม่ถูกรางวัล'));
    }
    else if(widget.rewards[lotteryNumber].keys.length == 1) {
      String lotteryType = widget.rewards[lotteryNumber].keys.toList()[0];
      return Column(
        children: [
          Text('ถูก${lotteryName[lotteryType]}'),
          const Text('เงินรางวัล'),
          Text(numberFormat(widget.rewards[lotteryNumber][lotteryType].toString())),
          const Text('บาท'),
        ],
      );
    }
    List lotteryType = widget.rewards[lotteryNumber].keys.toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('ถูกรางวัล'),
            Text('เงินรางวัล (บาท)'),
          ],
        ),
        for(int i=0; i<lotteryType.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ถูก${lotteryName[lotteryType[i]]}'),
              Text(numberFormat(widget.rewards[lotteryNumber][lotteryType[i]].toString()))
            ],
          ),
      ],
    );
  }
}
