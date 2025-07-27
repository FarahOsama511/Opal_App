import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tour_model.dart';
import 'dart:convert';

abstract class TourRemoteDataSource {
  Future<List<TourModel>> getAllTours();
  Future<Unit> addTour(TourModel tour);
  Future<Unit> updateTour(TourModel tour);
  Future<Unit> deleteTour(String id);
}

const Base_Url =
    'http://student-bus-service-api-oi5yen-ed9bc9-74-161-160-200.traefik.me/';

class TourRemoteDataSourceImpl implements TourRemoteDataSource {
  final http.Client client;

  TourRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TourModel>> getAllTours() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    final response = await client.get(
      Uri.parse('${Base_Url}tours'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse =
          jsonDecode(response.body) as List<dynamic>;
      print('the tours are: $jsonResponse');
      return jsonResponse.map((json) => TourModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addTour(TourModel tour) async {
    final body = {
      'id': tour.id,
      'type': tour.type,
      'driverName': tour.driverName,
      'leavesAt': tour.leavesAt.toIso8601String(),
      'line': {
        'id': tour.line.id,
        'name': tour.line.name,
        'createdAt': tour.line.createdAt!.toIso8601String(),
        'updatedAt': tour.line.updatedAt!.toIso8601String(),
      },
    };
    final response = await client.post(
      Uri.parse('${Base_Url}tours'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 201) {
      return unit;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateTour(TourModel tour) async {
    final body = {
      'id': tour.id,
      'type': tour.type,
      'driverName': tour.driverName,
      'leavesAt': tour.leavesAt.toIso8601String(),
      'line': {
        'id': tour.line.id,
        'name': tour.line.name,
        'createdAt': tour.line.createdAt!.toIso8601String(),
        'updatedAt': tour.line.updatedAt!.toIso8601String(),
      },
    };
    final response = await client.put(
      Uri.parse('${Base_Url}tours/${tour.id}'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return unit;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteTour(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final admintoken = prefs.getString('access_token_Admin');
    final response = await client.delete(
      Uri.parse('${Base_Url}tours/${id.toString()}'),
      headers: {'Authorization': 'Bearer $admintoken'},
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
