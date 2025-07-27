import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/features/Admin/Data/models/add_admin_supervisor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';

abstract class AddAdminSupervisorDatasource {
  Future<Unit> AddAdminOrSupervisor(AddAdminSupervisorModel addUser);
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class AddAdminSupervisorDatasourceImpl implements AddAdminSupervisorDatasource {
  final http.Client client;

  AddAdminSupervisorDatasourceImpl({required this.client});

  Future<Unit> AddAdminOrSupervisor(AddAdminSupervisorModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final adminToken = prefs.getString('access_token_Admin');
    final body = {
      'name': user.name,
      'phone': user.phone,
      'password': user.password,
      'email': user.email,
      'role': user.role,
    };
    final response = await client.post(
      Uri.parse('${Base_Url}users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${adminToken}',
      },
      body: jsonEncode(body), // ✅ هنا التحويل إلى JSON
    );

    if (response.statusCode == 201) {
      return unit;
    } else {
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      throw ServerException();
    }
  }
}
