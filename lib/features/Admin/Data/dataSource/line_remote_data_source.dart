import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opal_app/features/Admin/Data/models/line_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class LineRemoteDataSource {
  Future<List<LineModel>> getAllLines();
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class LineRemoteDataSourceImpl extends LineRemoteDataSource {
  final http.Client client;

  LineRemoteDataSourceImpl({required this.client});

  @override
  Future<List<LineModel>> getAllLines() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final response = await client.get(
      Uri.parse('${Base_Url}lines'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the lines are: $jsonResponse');
      return jsonResponse.map((json) => LineModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }
}
