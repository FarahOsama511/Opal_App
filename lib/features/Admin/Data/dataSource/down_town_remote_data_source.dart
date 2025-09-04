import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/features/Admin/Data/models/down_town_model.dart';
import 'package:opal_app/features/Admin/Domain/entities/down_town_entity.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';

abstract class DownTownRemoteDataSource {
  Future<List<DownTownModel>> getAllDownTown();
  Future<Unit> AddDownTown(DownTownEntity DownTown);
  Future<Unit> deleteDownTown(String id);
}

class DownTownRemoteDataSourceImpl extends DownTownRemoteDataSource {
  final http.Client client;

  DownTownRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DownTownModel>> getAllDownTown() async {
    final response = await client.get(
      Uri.parse('${Base_Url}downtown'),
      headers: {'Content-Type': 'application/json'},
    );
    print('Response encoding: ${response.headers['content-type']}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the downTown are: $jsonResponse');
      return jsonResponse.map((json) => DownTownModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> AddDownTown(DownTownEntity downTown) async {
    final body = jsonEncode({'name': downTown.name});
    final response = await client.post(
      Uri.parse('${Base_Url}downtown'),
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
  Future<Unit> deleteDownTown(String id) async {
    final response = await client.delete(
      Uri.parse('${Base_Url}downtown/${id}'),
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
}
