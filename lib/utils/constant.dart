final monthList = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

final lotteryName = {
  'lotto_one': 'รางวัลที่ 1',
  'lotto_first_three': 'เลขหน้า 3 ตัว',
  'lotto_last_three': 'เลขท้าย 3 ตัว',
  'lotto_last_two': 'เลขท้าย 2 ตัว',
  'lotto_one_special_first_group': 'รางวัลที่ 1 พิเศษกลุ่มที่ 1',
  'lotto_one_special_second_group': 'รางวัลที่ 1 พิเศษกลุ่มที่ 2',
  'lotto_side_one': 'รางวัลข้างเคียงรางวัลที่ 1',
  'lotto_two': 'รางวัลที่ 2',
  'lotto_three': 'รางวัลที่ 3',
  'lotto_four': 'รางวัลที่ 4',
  'lotto_five': 'รางวัลที่ 5',
};

String numberFormat(String reward) {
  String moneyReverse = '';
  for(int i=reward.length-1, j=1; i>=0; i--, j++) {
    moneyReverse += reward[i];
    if(j%3==0 && i!=0) {
      moneyReverse += ',';
    }
  }
  String money = '';
  for(int i=moneyReverse.length-1; i>=0; i--) {
    money += moneyReverse[i];
  }
  return money;
}

String dateFormat(String date) {
  return 'งวดวันที่ '
      '${int.parse(date.substring(8))} '
      '${monthList[int.parse(date.substring(5, 7))-1]} '
      '${date.substring(0, 4)}';
}