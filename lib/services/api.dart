import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lottery/models/api_result.dart';

class Api {
  // static const baseURL = 'http://localhost/lottery';
  static const baseURL = 'https://unikume-lottery-api.herokuapp.com';

  Future<dynamic> fetch(
      String endPoint, {
        Map<String, dynamic>? queryParams,
      }) async {
    String queryString = Uri(queryParameters: queryParams).query;
    var url = Uri.parse('$baseURL/$endPoint?$queryString');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // แปลง text ที่มีรูปแบบเป็น JSON ไปเป็น Dart's data structure (List/Map)
      Map<String, dynamic> jsonBody = json.decode(response.body);

      //print('RESPONSE BODY: $jsonBody');

      // แปลง Dart's data structure ไปเป็น model (POJO)
      var apiResult = ApiResult.fromJson(jsonBody);

      return apiResult.result;
    } else {
      throw 'Server connection failed!';
    }
  }

  Future<dynamic> fetchBody(
    String endPoint,
    Map<String, dynamic> bodyParams,
  ) async {
    var url = Uri.parse('$baseURL/$endPoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(bodyParams),
    );
    if (response.statusCode == 200) {
      // แปลง text ที่มีรูปแบบเป็น JSON ไปเป็น Dart's data structure (List/Map)
      Map<String, dynamic> jsonBody = json.decode(response.body);

      // print('RESPONSE BODY: $jsonBody');

      // แปลง Dart's data structure ไปเป็น model (POJO)
      var apiResult = ApiResult.fromJson(jsonBody);

      return apiResult.result;
    } else {
      throw 'Server connection failed!';
    }
  }
}
