class ApiResult {
  final int status;
  final String message;
  final dynamic result;

  ApiResult({
    required this.status,
    required this.message,
    required this.result,
  });

  factory ApiResult.fromJson(Map<String, dynamic> json) {
    final List results = [];
    json.forEach((key, value) => results.add(value));
    return ApiResult(
      status: results[0],
      message: results[1],
      result: results[2],
    );
  }
}