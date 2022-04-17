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

  // Widget _buildRewardSearch(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
  //     child: Card(
  //       elevation: 5,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(32.0),
  //       ),
  //       child: TextField(
  //         // controller: _searchController,
  //         decoration: const InputDecoration(
  //           hintStyle: TextStyle(fontSize: 17),
  //           hintText: 'ตรวจรางวัลสลากกินแบ่งรัฐบาล',
  //           prefixIcon: Icon(Icons.search),
  //           border: InputBorder.none,
  //           contentPadding: EdgeInsets.all(10.0),
  //         ),
  //         keyboardType: TextInputType.number,
  //         inputFormatters: [
  //           FilteringTextInputFormatter.digitsOnly,
  //         ],
  //         onSubmitted: (value) {
  //           if(value.length == 6) {
  //             // _searchController.clear();
  //             showMaterialDialog(context, 'title', 'msg');
  //           }
  //         },
  //       ),
  //     ),
  //   );
  // }
}
