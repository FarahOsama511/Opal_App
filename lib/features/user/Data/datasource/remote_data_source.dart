import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:opal_app/core/network/local_network.dart';
import 'package:opal_app/features/user/Data/models/register_model.dart';
import 'package:opal_app/features/user/Data/models/login_model.dart';

import '../../Domain/entities/authentity.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> loginStudent(String phone, String universityCardId);
  Future<LoginModel> loginAdminOrSuperVisor(
    String email,
    String password,
    String role,
  );
  Future<RegisterEntity> register(RegisterModel authModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});
  @override
  Future<LoginModel> loginStudent(String phone, String universityCardId) async {
    final body = {'phone': phone, 'universityCardId': universityCardId};

    final response = await client.post(
      Uri.parse('${Base_Url}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("=== login Response Status: ${response.statusCode} ===");
    print("=== login Response Body: ${response.body} ===");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse['user']['role']);
      await CacheNetwork.insertToCache(
        key: 'access_token',
        value: jsonResponse['token'],
      );
      token = jsonResponse['token'];
      print('Token saved and updated: $token');
      await CacheNetwork.insertToCache(
        key: 'access_role',
        value: jsonResponse['user']['role'],
      );
      return LoginModel.fromJson({...jsonResponse, 'token': token});
    } else {
      print('===============${response.body}================');
      throw ServerException();
    }
  }

  @override
  Future<RegisterEntity> register(RegisterModel authModel) async {
    final body = {
      'downTownId': authModel.user.downTown?.id,
      'name': authModel.user.name,
      'phone': authModel.user.phone,
      'universityCardId': authModel.user.universityCardId,
      'lineId': authModel.user.line?.id,
      'universityId': authModel.user.universityId,
    };
    print("=== Request Body: $body ===");

    final response = await client.post(
      Uri.parse('${Base_Url}auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("=== Register Response Status: ${response.statusCode} ===");
    print("=== Register Response Body: ${response.body} ===");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      print("===========${jsonResponse}===========");

      return RegisterModel.fromJson(jsonResponse);
    } else {
      throw ServerException();
    }
  }

  Future<LoginModel> loginAdminOrSuperVisor(
    String email,
    String password,
    String role,
  ) async {
    final body = {'email': email, 'password': password, 'role': role};
    final response = await client.post(
      Uri.parse('${Base_Url}auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print("=== login Response Status: ${response.statusCode} ===");
    print("=== login Response Body: ${response.body} ===");

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      await CacheNetwork.insertToCache(
        key: 'access_token',
        value: jsonResponse['token'],
      );
      token = jsonResponse['token']; // ← تحديث المتغير العام
      print('Token saved and updated: $token');
      await CacheNetwork.insertToCache(
        key: 'access_role',
        value: jsonResponse['user']['role'],
      );

      return LoginModel.fromJson({
        ...jsonResponse,
        'token': jsonResponse['token'],
      });
    } else {
      throw ServerException();
    }
  }
}
