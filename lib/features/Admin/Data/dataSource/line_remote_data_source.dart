import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/Admin/Data/models/line_model.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';

import '../../../../core/errors/exceptions.dart';

abstract class LineRemoteDataSource {
  Future<List<LineModel>> getAllLines();
  Future<Unit> AddLine(LineEntity line);
}

class LineRemoteDataSourceImpl extends LineRemoteDataSource {
  final http.Client client;
  String? tokenAdmin;

  LineRemoteDataSourceImpl({required this.client});

  @override
  Future<List<LineModel>> getAllLines() async {
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

  @override
  Future<Unit> AddLine(LineEntity line) async {
    if (token != null && token != "" && role == 'admin') {
      tokenAdmin = CacheNetwork.getCacheData(key: 'access_token');
    }
    final body = jsonEncode({'name': line.name});
    final response = await client.post(
      Uri.parse('${Base_Url}lines'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenAdmin',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return unit;
    } else {
      throw ServerException();
    }
  }
}
