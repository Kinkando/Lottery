class ApiResult {
  final bool status;
  final String drawDate;
  final List<dynamic> result;

  ApiResult({
    required this.status,
    required this.drawDate,
    required this.result,
  });

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    return ApiResult(
      status: json['status'],
      drawDate: json['drawdate'],
      result: json['result'],
    );
  }
}