import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/university_model.dart';

abstract class UniversityDataSource {
  Future<List<UniversityModel>> getAllUniversity();
  Future<UniversityModel> getUniversityById(String id);
  Future<UniversityModel> addUniversity(UniversityModel university);
  Future<Unit> deleteUniversity(String id);
}

class UniversityDataSourceImpl implements UniversityDataSource {
  final http.Client client;
  UniversityDataSourceImpl({required this.client});

  @override
  Future<List<UniversityModel>> getAllUniversity() async {
    final response = await client.get(Uri.parse('${Base_Url}universities'));

    print(
      "=== Get All universities Response Status: ${response.statusCode} ===",
    );
    print("=== Get All universities Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the universitys are: $jsonResponse');
      return jsonResponse
          .map((json) => UniversityModel.fromJson(json))
          .toList();
    } else {
      print("status code${response.statusCode}");
      print("Body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<UniversityModel> getUniversityById(String id) async {
    final response = await client.get(
      Uri.parse('${Base_Url}universities/${id}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('the university is: $jsonResponse');
      final university = UniversityModel.fromJson(jsonResponse);

      return university;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<UniversityModel> addUniversity(UniversityModel university) async {
    final body = {'name': university.name, 'location': university.location};
    final response = await client.post(
      Uri.parse('${Base_Url}universities'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      print('the added university is: $jsonResponse');
      return UniversityModel.fromJson(jsonResponse);
    } else {
      print("status code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteUniversity(String id) async {
    final response = await client.delete(
      Uri.parse('${Base_Url}universities/${id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );
    if (response.statusCode == 204) {
      print("status code is ${response.statusCode}");
      print("body:${response.body}");
      return unit;
    } else {
      print("status code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }
}
