import 'package:flutter/material.dart';
import 'package:lottery/services/api.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final _dropdownController = ScrollController();
  final _statController = ScrollController();
  final _tab = ["สถิติตามวัน", "สถิติตามเดือน", "สถิติตามปี"];
  final List<String> _weekdayTH = ['วันอาทิตย์', 'วันจันทร์', 'วันอังคาร', 'วันพุธ', 'วันพฤหัสบดี', 'วันศุกร์', 'วันเสาร์'];
  final _weekdayEN = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final _month = ["มกราคม", 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'];
  int _tabIndex = 0;
  final Map<String, int> _weekdayTabIndex = {'weekday': 0, 'retrospect': 10};
  final Map<String, int> _monthTabIndex = {'month': 0, 'retrospect': 10};
  final Map<String, int> _yearTabIndex = {'retrospect': 10};
  late List<String> _retrospectList;
  late Map<String, dynamic> _stat;
  bool _loading = true;
  bool _loadingStat = false;

  void _fetchStat() async {
    Map<String, dynamic> queryParams = {};
    switch(_tabIndex) {
      case 0 :
        queryParams['weekday'] = _weekdayEN[_weekdayTabIndex['weekday']!];
        queryParams['retrospect'] = '${_weekdayTabIndex['retrospect']}';
        break;
      case 1 :
        queryParams['month'] = '${_monthTabIndex['month']!+1}';
        queryParams['retrospect'] = '${_monthTabIndex['retrospect']}';
        break;
      default :
        queryParams['retrospect'] = '${_yearTabIndex['retrospect']}';
        break;
    }
    setState(() => _loadingStat = true);
    final Map<String, dynamic>? map = await Api().fetch('lottery/stat', queryParams: queryParams);
    if(map != null) {
      setState(() {
        _stat = map;
        _loading = false;
        _loadingStat = false;
      });
    }
  }

  void _fetchRetrospectYear() async {
    List list = await Api().fetch('lottery/years');
    List<String> years = [];
    for(int i=0; i<list.length-1; i++) {
      years.add('${int.parse(list[list.length-1])-int.parse(list[i])} ปีย้อนหลัง');
    }
    setState(() => _retrospectList = years);
  }

  @override
  void initState() {
    super.initState();
    _fetchRetrospectYear();
    _fetchStat();
  }

  @override
  Widget build(BuildContext context) {
    if(_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        _buildTabMenu(),
        _buildComboBox(context),
        _buildStat(),
      ],
    );
  }

  Widget _buildStat() {
    if(_loadingStat) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    // print(_stat);
    List<Widget> widgets = [
      for(int i=0; i<3; i++)
        _buildStatCard(i),
    ];
    return Expanded(
      child: CustomScrollView(
        slivers: widgets,
      ),
    );
  }

  Widget _buildStatCard(int index) {
    return SliverStickyHeader(
      header: Container(
        height: 60.0,
        color: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          'Header #$index',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, i) =>
          ListTile(
              leading: const CircleAvatar(
                child: Text('0'),
              ),
            title: Text('List tile #$i'),
          ),
          childCount: 20,
        ),
      ),
    );
  }

  Widget _buildComboBox(BuildContext context) {
    final mainMenu = [];
    switch(_tabIndex) {
      case 0 :
        mainMenu.add({
          "itemList": _weekdayTH,
          "currentIndex": _weekdayTabIndex['weekday'],
          "item": _weekdayTH[_weekdayTabIndex['weekday']!],
        });
        mainMenu.add({
          "itemList": _retrospectList,
          "currentIndex": _retrospectList.length - _weekdayTabIndex["retrospect"]!,
          "item": '${_weekdayTabIndex["retrospect"]} ปีย้อนหลัง',
        });
        break;
      case 1 :
        mainMenu.add({
          "itemList": _month,
          "currentIndex": _monthTabIndex['month'],
          "item": _month[_monthTabIndex['month']!],
        });
        mainMenu.add({
          "itemList": _retrospectList,
          "currentIndex": _retrospectList.length - _monthTabIndex["retrospect"]!,
          "item": '${_monthTabIndex["retrospect"]} ปีย้อนหลัง',
        });
        break;
      case 2 :
        mainMenu.add({
          "itemList": _retrospectList,
          "currentIndex": _retrospectList.length - _yearTabIndex["retrospect"]!,
          "item": '${_yearTabIndex["retrospect"]} ปีย้อนหลัง',
        });
        break;
      default : break;
    }
    return Row(
      children: [
        for(int i=0; i<mainMenu.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: i==0 ? 8.0 : 0.0, right: 8.0),
              child: OutlinedButton(
                onPressed: () => _buildDropdownPopup(context, mainMenu[i]['itemList'], mainMenu[i]['currentIndex']),
                child: Row(
                  children: [
                    Expanded(child: Text("${mainMenu[i]["item"]}")),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _buildDropdownPopup(BuildContext context, itemList, currentIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder( // setState in AlertDialog
            builder: (BuildContext contexts, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView(
                  controller: _dropdownController,
                  shrinkWrap: true,
                  children: [
                    for(int i=0; i<itemList.length; i++)
                      _dropdownItem(itemList[i], i, currentIndex, contexts),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _dropdownItem(item, index, currentIndex, BuildContext contexts) {
    return InkWell(
      onTap: () {
        setState(() {
          if(_weekdayTH.contains(item)) {
            _weekdayTabIndex['weekday'] = index;
          }
          else if(_month.contains(item)) {
            _monthTabIndex['month'] = index;
          }
          else if(_retrospectList.contains(item)) {
            int idx = int.parse(item.substring(0, item.indexOf(" ")));
            if(_tabIndex == 0) {
              _weekdayTabIndex['retrospect'] = idx;
            }
            else if(_tabIndex == 1) {
              _monthTabIndex['retrospect'] = idx;
            }
            else if(_tabIndex == 2) {
              _yearTabIndex['retrospect'] = idx;
            }
          }
          if(currentIndex != index) {
            _fetchStat();
          }
        });
        Navigator.of(context).pop();
      },
      child: Row(
        children: [
          Expanded(child: Text(item)),
          Icon(currentIndex == index ? Icons.done : Icons.clear ),
        ],
      ),
    );
  }

  Widget _buildTabMenu() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              for(int i=0; i<_tab.length; i++)
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _tabIndex = i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Text(
                              _tab[i],
                              style: i == _tabIndex ? const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ) : const TextStyle(),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  for(int i=0; i<_tab.length; i++)
                    Expanded(
                      child: i == _tabIndex ? Container(
                        height: 5.0,
                        color: Colors.blue,
                      ) : const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
            const Divider(
              thickness: 1.0,
              height: 1,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
