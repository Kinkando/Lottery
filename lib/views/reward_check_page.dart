import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery/services/api.dart';
import 'package:lottery/utils/constant.dart';
import 'package:lottery/utils/dialog.dart';
import 'package:lottery/views/reward_page.dart';

class RewardCheckPage extends StatefulWidget {
  const RewardCheckPage({Key? key}) : super(key: key);

  @override
  _RewardCheckPageState createState() => _RewardCheckPageState();
}

class _RewardCheckPageState extends State<RewardCheckPage> {
  final _drawDateScrollController = ScrollController();
  final _scrollController = ScrollController();
  final List<TextEditingController> _numberController = [TextEditingController()];
  late List _drawDateList;
  late String _date;
  late Map<String, dynamic> _rewards;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('lottery/dates', queryParams: {'limit': '100'});
    setState(() {
      _drawDateList = list;
      _date = list[0];
      _loading = false;
    });
  }

  Future<bool> _checkLottery() async {
    List<String> numbers = [];
    for(int i=0; i<_numberController.length; i++) {
      numbers.add(_numberController[i].text);
    }
    Map<String, dynamic>? rewards = await Api().fetchBody('lottery/check/$_date', {'numbers': numbers});
    if(rewards != null) {
      setState(() => _rewards = rewards);
    }
    return rewards != null;
  }

  @override
  Widget build(BuildContext context) {
    if(_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDrawDate(context),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(height: 10.0,),
            ),
            _buildLotteryNumberField(context),
            _buildCheckButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLotteryNumberField(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        controller: _scrollController,
        children: [
          for(int i=0; i<_numberController.length; i++)
            _buildRewardSearch(context, i),
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
              Expanded(child: Text(dateFormat(_date))),
            ],
          ),
        ),
      ),
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
            child: Text(dateFormat(date)),
          ),
          Icon(_date == date ? Icons.done : Icons.clear),
          const SizedBox(width: 10.0), //Space for scrollbar
        ],
      ),
    );
  }

  Widget _buildRewardSearch(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _numberController[index],
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontSize: 17),
                    hintText: 'กรอกเลขสลากของคุณ',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  onChanged: (value) {
                    if(value.length == 6) {
                      for(int i=0; i<_numberController.length; i++) {
                        if(value == _numberController[i].text && index != i) {
                          setState(() =>_numberController[index].clear());
                          showMaterialDialog(context, 'คุณระบุหมายเลขสลากนี้แล้ว');
                          break;
                        }
                      }
                    }
                  },
                ),
              ),
              if(_numberController.length > 1)
                InkWell(
                  // borderRadius: BorderRadius.circular(50.0),
                  customBorder: const CircleBorder(),
                  child: const Center(
                      child: Icon(Icons.clear, color: Colors.grey),
                  ),
                  onTap: () => setState(() =>_numberController.removeAt(index)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  for(int i=0; i<_numberController.length; i++) {
                    if(_numberController[i].text.length != 6) {
                      showMaterialDialog(context, 'เลขสลากไม่ถูกต้อง กรุณาตรวจสอบอีกครั้ง');
                      return;
                    }
                  }
                  await _checkLottery();
                  final List<String> numbers = [];
                  for(int i=0; i<_numberController.length; i++) {
                    numbers.add(_numberController[i].text);
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RewardPage(numbers: numbers, rewards: _rewards, date: _date)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  )
                ),
                child: const Text('ตรวจสลาก'),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _numberController.add(TextEditingController())),
              child: Container(
                width: 50.0,
                height: 50.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
