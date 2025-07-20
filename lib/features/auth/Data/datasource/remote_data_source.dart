import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/features/auth/Data/models/register_model.dart';
import 'package:opal_app/features/auth/Data/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Domain/entities/authentity.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login(String phone, String universityCardId);
  Future<RegisterEntity> register(RegisterModel authModel);
  //Future<Unit> logout();
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});
  @override
  Future<LoginModel> login(String phone, String universityCardId) async {
    final body = {'phone': phone, 'universityCardId': universityCardId};

    final response = await client.post(
      Uri.parse('${Base_Url}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print("=== login Response Status: ${response.statusCode} ===");
    print("=== login Response Body: ${response.body} ===");
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];
      await prefs.setString('access_token', token);

      return LoginModel.fromJson({...jsonResponse, 'token': token});
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RegisterEntity> register(RegisterModel authModel) async {
    final body = {
      'name': authModel.user.name,
      'phone': authModel.user.phone,
      'universityCardId': authModel.user.universityCardId,
      'lineId': authModel.user.line?.id,
      'universityId': authModel.user.universityId,
    };
    final response = await client.post(
      Uri.parse('${Base_Url}auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("=== Register Response Status: ${response.statusCode} ===");
    print("=== Register Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // final token = jsonResponse['token'];
      // await prefs.setString('access_token', token);

      return RegisterModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }
}
