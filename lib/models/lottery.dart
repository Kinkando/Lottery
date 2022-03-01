class Lottery {
  final String drawDate;
  final String id;
  final String name;
  final int reward;
  final int amount;
  var number;

  Lottery({
    required this.drawDate,
    required this.id,
    required this.name,
    required this.reward,
    required this.amount,
    required this.number,
  });

  factory Lottery.fromJson(Map<String, dynamic> json, String drawDate) {
    return Lottery(
      drawDate: drawDate,
      id: json['id'],
      name: json['name'],
      reward: json['reward'],
      amount: json['amount'],
      number: json['number'],
    );
  }

  String _number(String a) {
    return a;
  }
}