import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../Domain/entities/line_entity.dart';
import '../models/line_model.dart';

abstract class LineRemoteDataSource {
  Future<List<LineModel>> getAllLines();
  Future<Unit> addLine(LineEntity line);
  Future<LineModel> getLineById(String id);
  Future<Unit> deleteLine(String id);
  Future<Unit> updateLine(LineEntity line);
}

class LineRemoteDataSourceImpl extends LineRemoteDataSource {
  final http.Client client;

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
  Future<Unit> addLine(LineEntity line) async {
    final body = jsonEncode({'name': line.name, 'notes': line.notes});
    final response = await client.post(
      Uri.parse('${Base_Url}lines'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      return unit;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LineModel> getLineById(String id) async {
    final response = await client.get(
      Uri.parse('${Base_Url}lines/${id}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('the Line is: $jsonResponse');
      final line = LineModel.fromJson(jsonResponse);

      return line;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteLine(String id) async {
    final response = await client.delete(
      Uri.parse('${Base_Url}lines/${id}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      return unit;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  Future<Unit> updateLine(LineEntity line) async {
    final body = jsonEncode({
      'name': line.name,
      'notes': line.notes,
      'id': line.id,
    });
    final response = await client.put(
      Uri.parse('${Base_Url}lines/${line.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException();
    }
  }
}
