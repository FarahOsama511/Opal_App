import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/constants/constants.dart';
import 'package:opal_app/features/Admin/Data/models/add_admin_supervisor_model.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/local_network.dart';

abstract class AddAdminSupervisorDatasource {
  Future<Unit> AddAdminOrSupervisor(AddAdminSupervisorModel addUser);
}

class AddAdminSupervisorDatasourceImpl implements AddAdminSupervisorDatasource {
  final http.Client client;
  String? tokenAdmin;
  AddAdminSupervisorDatasourceImpl({required this.client});

  Future<Unit> AddAdminOrSupervisor(AddAdminSupervisorModel user) async {
    if (token != null && token != "" && role == 'admin') {
      tokenAdmin = CacheNetwork.getCacheData(key: 'access_token');
    }
    final body = {
      'name': user.name,
      'phone': user.phone,
      'password': user.password,
      'email': user.email,
      'role': user.role,
      'lineId': user.lineId,
    };
    final response = await client.post(
      Uri.parse('${Base_Url}users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${tokenAdmin}',
      },
      body: jsonEncode(body),
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
