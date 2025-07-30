import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAllUser();
  Future<UserModel> userIsActivate(String id, String status);
  Future<UserModel> userIsDeactivate(String id, String status);
  Future<UserModel> getUserById(String userId);
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getAllUser() async {
    final response = await client.get(
      Uri.parse('${Base_Url}users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenAdmin',
      },
    );

    print("=== Get All Users Response Status: ${response.statusCode} ===");
    print("=== Get All Users Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the users are: $jsonResponse');
      return jsonResponse.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> userIsActivate(String id, String status) async {
    final response = await client.post(
      Uri.parse('${Base_Url}users/${id}/activate'),
      headers: {'Authorization': 'Bearer $tokenAdmin'},
    );

    print("=== Get userisActivate Response Status: ${response.statusCode} ===");
    print("=== Get userisActivate Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final user = UserModel.fromJson(jsonMap);
      print('the usersActivate are: $user');
      return user;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> userIsDeactivate(String id, String status) async {
    final response = await client.post(
      Uri.parse('${Base_Url}users/${id}/deactivate'),
      headers: {'Authorization': 'Bearer $tokenAdmin'},
    );

    print(
      "=== Get userisdeactivate Response Status: ${response.statusCode} ===",
    );
    print("=== Get userisdeactivate Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      final user = UserModel.fromJson(jsonMap);
      print('the usersdeactivate are: $user');
      return user;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    final response = await client.get(
      Uri.parse('${Base_Url}users/${userId}'),
      headers: {'Authorization': 'Bearer $tokenAdmin'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('the supervisor is: $jsonResponse');
      final user = UserModel.fromJson(jsonResponse);

      return user;
    } else {
      print("state code is ${response.statusCode}");
      print("body:${response.body}");
      throw ServerException();
    }
  }
}
