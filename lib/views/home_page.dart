import 'package:flutter/material.dart';
import 'package:lottery/models/lottery.dart';
import 'package:lottery/services/api.dart';
import 'package:lottery/utils/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _drawDateScrollController = ScrollController();
  final _lotteryScrollController = ScrollController();
  final _gridViewController = ScrollController();
  String _date = '';
  bool _loading = true;
  late List _drawDateList;
  late Lottery _lottery;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('lottery/dates');
    final Map<String, dynamic> result = await Api().fetch('lottery', queryParams: {'date': list[0]});
    final lottery = Lottery.fromJson(result);
    setState(() {
      _drawDateList = list;
      _date = list[0];
      _lottery = lottery;
      _loading = false;
    });
  }

  void _fetchLottery() async {
    setState(() {
      _loading = true;
    });
    final Map<String, dynamic> result = await Api().fetch('lottery', queryParams: {'date': _date});
    final lottery = Lottery.fromJson(result);
    setState(() {
      _lottery = lottery;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_loading && _date.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildRewardSearch(context),
          _buildDrawDate(context),
          _buildLotteryNumber(),
        ],
      ),
    );
  }

  Widget _buildDrawDate(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => _drawDateSelected(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today),
              const SizedBox(width: 10.0),
              Expanded(child: Text(_dateFormat(_date))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLotteryNumber() {
    List<LotteryNumber> lotteryNumber = [];
    _lottery.lottery.forEach((element) => lotteryNumber.add(element));
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top:10.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const Center(child: CircularProgressIndicator())
        ),
      ),
    );
  }

  Widget _buildLottery(LotteryNumber lottery) {
    String reward = 'รางวัลละ ${numberFormat(lottery.reward.toString())} บาท';
    if(lottery.number.runtimeType == List && lottery.number.length >=5) {
      reward = '${lottery.number.length} รางวัล $reward';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(lotteryName[lottery.name]!),
          if(lottery.set != null)
            Text('ชุดที่ ${lottery.set}'),
          Text(reward),
          _lotteryNumber(lottery.number),
        ],
      ),
    );
  }

  Widget _lotteryNumber(number) {
    if(number.runtimeType != List) {
      return Text(number);
    }
    else if(number.length <= 2) {
      return Column(
        children: [
          for(int i=0; i<number.length; i++)
            Text(number[i]),
        ],
      );
    }
    return GridView(
      controller: _gridViewController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 20.0,
      ),
      shrinkWrap: true,
      children: [
        for(int i=0; i<number.length; i++)
          Center(child: Text(number[i])),
      ],
    );
  }

  void _drawDateSelected(BuildContext context) {
    String temp = _date;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ตรวจหวยย้อนหลัง',
            textAlign: TextAlign.center,
          ),
          content: StatefulBuilder( // setState in AlertDialog
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  controller: _drawDateScrollController,
                  shrinkWrap: true,
                  children: [
                    for(int i=0; i<_drawDateList.length; i++)
                      _datePicker(_drawDateList[i], setState),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                setState(() {
                  _date = temp;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if(_date != temp) {
                  _fetchLottery();
                }
                setState(() {
                  _date = _date;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _datePicker(String date, StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          _date = date;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Text(_dateFormat(date)),
          ),
          Icon(_date == date ? Icons.done : Icons.clear),
          const SizedBox(width: 10.0), //Space for scrollbar
        ],
      ),
    );
  }

  String _dateFormat(String date) {
    return 'งวดวันที่ '
        '${int.parse(date.substring(8))} '
        '${monthList[int.parse(date.substring(5, 7))-1]} '
        '${date.substring(0, 4)}';
  }
}
