import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/features/user/Data/models/university_model.dart';
import 'package:opal_app/features/user/Domain/entities/university_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class UniversityDataSource {
  Future<List<UniversityEntity>> getAllUniversity();
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class UniversityDataSourceImpl implements UniversityDataSource {
  final http.Client client;

  UniversityDataSourceImpl({required this.client});

  @override
  Future<List<UniversityModel>> getAllUniversity() async {
    print("Admin token is${tokenAdmin}");
    final response = await client.get(
      Uri.parse('${Base_Url}universities'),
      //headers: {'Authorization': 'Bearer $userToken'},
    );

    print(
      "=== Get All universities Response Status: ${response.statusCode} ===",
    );
    print("=== Get All universities Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the users are: $jsonResponse');
      return jsonResponse
          .map((json) => UniversityModel.fromJson(json))
          .toList();
    } else {
      print("status code${response.statusCode}");
      print("Body:${response.body}");
      throw ServerException();
    }
  }
}
