import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:opal_app/core/errors/exceptions.dart';
import '../models/tour_model.dart';

abstract class TourRemoteDataSource {
  Future<List<TourModel>> getAllTours();
  Future<Unit> addTour(TourModel tour);
  Future<Unit> updateTour(TourModel tour);
  Future<Unit> deleteTour(String id);
}

const Base_Url = 'http://localhost:3000/';

class TourRemoteDataSourceImpl implements TourRemoteDataSource {
  final http.Client client;

  TourRemoteDataSourceImpl({required this.client});
  @override
  Future<List<TourModel>> getAllTours() async {
    final response = await client.get(Uri.parse('${Base_Url}tours'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = response.body as List<dynamic>;
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
        'createdAt': tour.line.createdAt.toIso8601String(),
        'updatedAt': tour.line.updatedAt.toIso8601String(),
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
        'createdAt': tour.line.createdAt.toIso8601String(),
        'updatedAt': tour.line.updatedAt.toIso8601String(),
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
    final response = await client.delete(
      Uri.parse('${Base_Url}tours/${id.toString()}'),
    );

    if (response.statusCode == 204) {
      return unit;
    } else {
      throw ServerException();
    }
  }
}
