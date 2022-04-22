import 'package:flutter/material.dart';
import 'package:lottery/services/api.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  final _customScrollViewController = [ScrollController(), ScrollController(), ScrollController()];
  final _dropdownController = ScrollController();
  final _tab = ["สถิติตามวัน", "สถิติตามเดือน", "สถิติตามปี"];
  final List<String> _weekdayTH = ['วันอาทิตย์', 'วันจันทร์', 'วันอังคาร', 'วันพุธ', 'วันพฤหัสบดี', 'วันศุกร์', 'วันเสาร์'];
  final _weekdayEN = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final _month = ["มกราคม", 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน', 'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'];
  int _tabIndex = 0;
  final Map<String, int> _weekdayTabIndex = {'weekday': 0, 'retrospect': 10};
  final Map<String, int> _monthTabIndex = {'month': 0, 'retrospect': 10};
  final Map<String, int> _yearTabIndex = {'retrospect': 10};
  late List<String> _retrospectList;
  final Map<String, dynamic> _stat = {};
  bool _loading = true;
  bool _loadingStat = false;

  void _fetchInit() async {
    // *************** YEARS ********************
    List list = await Api().fetch('lottery/years');
    List<String> years = [];
    for(int i=0; i<list.length-1; i++) {
      years.add('${int.parse(list[list.length-1])-int.parse(list[i])} ปีย้อนหลัง');
    }
    setState(() => _retrospectList = years);

    // *************** STAT **********************
    final queryParams = [
      {
        'weekday': _weekdayEN[_weekdayTabIndex['weekday']!],
        'retrospect': '${_weekdayTabIndex['retrospect']}',
      },
      {
        'month': '${_monthTabIndex['month']!+1}',
        'retrospect': '${_monthTabIndex['retrospect']}',
      },
      {
        'retrospect': '${_yearTabIndex['retrospect']}',
      },
    ];
    final Map<String, dynamic> weekdayMap = await Api().fetch('lottery/stat', queryParams: queryParams[0]);
    final Map<String, dynamic> monthMap = await Api().fetch('lottery/stat', queryParams: queryParams[1]);
    final Map<String, dynamic> yearMap = await Api().fetch('lottery/stat', queryParams: queryParams[2]);
    setState(() {
      _stat['weekday'] = weekdayMap;
      _stat['month'] = monthMap;
      _stat['year'] = yearMap;
      _loading = false;
    });
  }

  void _fetchStat() async {
    Map<String, dynamic> queryParams = {};
    String key = "";
    switch(_tabIndex) {
      case 0 :
        queryParams['weekday'] = _weekdayEN[_weekdayTabIndex['weekday']!];
        queryParams['retrospect'] = '${_weekdayTabIndex['retrospect']}';
        key = "weekday";
        break;
      case 1 :
        queryParams['month'] = '${_monthTabIndex['month']!+1}';
        queryParams['retrospect'] = '${_monthTabIndex['retrospect']}';
        key = "month";
        break;
      default :
        queryParams['retrospect'] = '${_yearTabIndex['retrospect']}';
        key = "year";
        break;
    }
    setState(() => _loadingStat = true);
    final Map<String, dynamic> map = await Api().fetch('lottery/stat', queryParams: queryParams);
    setState(() {
      _stat[key] = map;
      _loadingStat = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInit();
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

  String _getCurrentStat() => ['weekday', 'month', 'year'][_tabIndex];

  Widget _buildStat() {
    if(_loadingStat) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    List<Widget> widgets = [
      for(var key in _stat[_getCurrentStat()].keys)
        _buildStatCard(key, _stat[_getCurrentStat()][key]),
    ];
    return Expanded(
      child: CustomScrollView(
        controller: _customScrollViewController[_tabIndex],
        slivers: widgets,
      ),
    );
  }

  Widget _buildStatCard(String key, value) {
    List keys = [
      for(var key in value.keys)
        if(int.tryParse(key) != null)
          key
    ];
    keys.sort((a, b) { // sorting from frequency of lottery number and number order sort
      int result = value[a].compareTo(value[b]);
      return result == 0 ? (int.parse(a).compareTo(int.parse(b))) : result * -1;
    });
    return SliverStickyHeader(
      header: Container(
        // margin: const EdgeInsets.only(bottom: 20.0),
        height: 60.0,
        color: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Text(
          key,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) =>
          ListTile(
              leading: CircleAvatar(
                child: Text('${value[keys[index]]}'),
              ),
            title: Text(keys[index]),
            // title: Text('List tile #$i'),
          ),
          childCount: keys.length,
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
                        onTap: () => setState(() {
                          // if(_tabIndex != i) {
                          //   _fetchStat();
                          // }
                          _tabIndex = i;
                        }),
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
