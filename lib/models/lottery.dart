class Lottery {
  final String drawDate;
  final List<LotteryNumber> lottery;

  Lottery({
    required this.drawDate,
    required this.lottery,
  });

  factory Lottery.fromJson(Map<String, dynamic> json) {
    final List<LotteryNumber> lottery = [];
    json.forEach((key, value) {
      if(key != 'drawdate') {
        lottery.add(LotteryNumber.fromJson(key, value));
      }
    });
    return Lottery(
      drawDate: json['drawdate'],
      lottery: lottery,
    );
  }
}

class LotteryNumber {
  final String name;
  final int reward;
  final int? set;
  final dynamic number;

  LotteryNumber({
    required this.name,
    required this.reward,
    required this.set,
    required this.number,
  });

  factory LotteryNumber.fromJson(String drawDate, Map<String, dynamic> json) {
    return LotteryNumber(
      name: drawDate,
      reward: json['reward'],
      set: json.containsKey('set') ? json['set'] : null,
      number: json['number'],
    );
  }
}